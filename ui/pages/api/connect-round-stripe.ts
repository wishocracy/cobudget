import { appLink } from "utils/internalLinks";
import handler from "server/api-handler";
import { isCollOrGroupAdmin } from "server/graphql/resolvers/helpers";
import prisma from "server/prisma";
import stripe from "server/utils/stripe";

export default handler().get(async (req, res) => {
  if (typeof req.query?.roundId !== "string") throw new Error("Bad roundId");
  const roundId = req.query?.roundId;

  // throws if not
  await isCollOrGroupAdmin(null, { roundId }, { user: req.user });

  const round = await prisma.round.findUnique({
    where: { id: roundId },
    include: { group: true },
  });

  let accountId: string = null;

  if (!round.stripeAccountId) {
    const account = await stripe.accounts.create({ type: "standard" });

    await prisma.round.update({
      where: { id: roundId },
      data: { stripeAccountId: account.id },
    });

    accountId = account.id;
  }

  accountId ??= round.stripeAccountId;

  // TODO: we can't have a dynamic link here, it has to be pre-filled in the stripe settings
  const callbackLink = appLink(`/${round.group.slug}/${round.slug}/settings`);

  const accountLink = await stripe.accountLinks.create({
    account: accountId,
    refresh_url: callbackLink,
    return_url: callbackLink,
    type: "account_onboarding",
  });

  res.redirect(accountLink.url);
});
