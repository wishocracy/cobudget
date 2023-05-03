import passport from 'passport';
import { Strategy as LocalStrategy } from 'passport-local';
import { getWeb3 } from './web3';
import prisma from '../prisma/client';

passport.use(
  'web3',
  new LocalStrategy(async (username, signature, done) => {
    try {
      const web3 = await getWeb3();
      const recoveredAddress = web3.eth.accounts.recover(username, signature);

      // Check if the user exists in the database
      let user = await prisma.user.findUnique({
        where: { ethereumAddress: recoveredAddress },
      });

      // If the user does not exist, create a new user
      if (!user) {
        user = await prisma.user.create({
          data: { ethereumAddress: recoveredAddress },
        });
      }

      return done(null, user);
    } catch (error) {
      return done(error);
    }
  })
);