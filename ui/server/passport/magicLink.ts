import MagicLoginStrategy from "passport-magic-login";
import AppError from "server/utils/AppError";
import emailService from "../services/EmailService/email.service";
import { createOrGetUser } from "./helpers";

if (!process.env.MAGIC_LINK_SECRET)
  throw new Error(`Add MAGIC_LINK_SECRET environment variable`);

  console.log(process.env.MAGIC_LINK_SECRET, process.env.DATABASE_URL);

const magicLink = new MagicLoginStrategy({
  secret: process.env.MAGIC_LINK_SECRET,
  callbackUrl: "/api/auth/magiclink/callback",
  sendMagicLink: async (destination, href, code, req) => {
    await emailService.loginMagicLink({ destination, href, code, req });
  },
  verify: (payload, callback) => {
    if (payload === false) {
      return callback(new AppError("Invalid Token", 400));
    }

    const email = payload.destination.toLowerCase().trim();

    createOrGetUser({ email })
      .then((user) => {
        callback(null, { ...user, redirect: payload.redirect });
      })
      .catch((err) => callback(err));
  },
});

export default magicLink;
