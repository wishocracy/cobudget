
  import nextConnect from 'next-connect';
  import passport from 'passport';
  import { setLoginSession, getLoginSession } from './lib/auth';
  import callback from "./callback"
  
  const handler = nextConnect();
  
  handler.use(passport.initialize());
  
  handler.post(async (req, res) => {
    try {
      const user = await authenticateWeb3User(req, res);
      const session = { ...user };
      await setLoginSession(res, session);
      res.status(200).json({ user });
    } catch (error) {
      res.status(401).json({ error: 'Unauthorized' });
    }
  });
  
  const authenticateWeb3User = (req, res) =>
    new Promise((resolve, reject) => {
      passport.authenticate('web3', (error, user) => {
        if (error) {
          return reject(error);
        }
        if (!user) {
          return reject(new Error('Unauthorized'));
        }
        return resolve(user);
      })(req, res);
    });
  
  export default handler; 