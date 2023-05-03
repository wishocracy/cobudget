import passport from "passport";
import handler from "../../../../server/api-handler";

export default handler()
  .use(passport.authenticate("magiclogin"))
  .use((req, res) => {
    console.log(req.user, req.user?.redirect || "/")
    res.redirect(req.user?.redirect || "/");
  });
