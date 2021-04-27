import React from "react";
import Head from "next/head";
import Header from "./Header";

const Layout = ({
  children,
  currentUser,
  currentOrgMember,
  currentOrg,
  event,
  title,
  openModal,
  router,
}) => {
  return (
    <div style={{ "min-height": "100vh" }} className="flex flex-col">
      <Head>
        <title>
          {title
            ? `${title} | Dreams`
            : event
            ? `${event.title} | Dreams`
            : "Dreams"}
        </title>
        <meta
          name="viewport"
          content="minimum-scale=1, initial-scale=1, width=device-width, shrink-to-fit=no"
        />
      </Head>
      <div>
        <Header
          event={event}
          currentUser={currentUser}
          currentOrgMember={currentOrgMember}
          currentOrg={currentOrg}
          openModal={openModal}
          router={router}
        />
        <div className="mx-2 md:mx-4 pb-10 flex justify-center">{children}</div>
      </div>

      {/* {process.env.IS_PROD && <DevelopmentNotice />} */}
      <div className="space-x-2 text-sm text-center mt-auto py-10">
        <a
          href="https://www.iubenda.com/privacy-policy/58637640/cookie-policy"
          target="_blank"
          rel="noreferrer"
        >
          Cookie Policy
        </a>
        <span>|</span>
        <a
          href="https://www.iubenda.com/privacy-policy/58637640"
          target="_blank"
          rel="noreferrer"
        >
          Privacy Policy
        </a>
        <span>|</span>
        <a
          href="https://www.iubenda.com/terms-and-conditions/58637640"
          target="_blank"
          rel="noreferrer"
        >
          Terms and Conditions
        </a>
      </div>
    </div>
  );
};

export default Layout;
