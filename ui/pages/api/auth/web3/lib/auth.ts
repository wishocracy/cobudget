import cookie from 'cookie';
import jwt from 'jsonwebtoken';

export const setLoginSession = (res, session) => {
  const sessionData = JSON.stringify(session);
  const sessionToken = jwt.sign(sessionData, process.env.JWT_SECRET);

  res.setHeader('Set-Cookie', cookie.serialize('session', sessionToken, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    maxAge: 60 * 60 * 24 * 7 // 1 week
  }));
};

export const getLoginSession = (req) => {
  const sessionToken = req.cookies.session;
  if (!sessionToken) return null;

  try {
    const sessionData = jwt.verify(sessionToken, process.env.JWT_SECRET);
    return JSON.parse(sessionData);
  } catch (error) {
    return null;
  }
};
