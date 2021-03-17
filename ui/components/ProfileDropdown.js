import React, { useEffect } from "react";
import { Badge } from "@material-ui/core";
import Avatar from "./Avatar";
import { modals } from "./Modal/index";
import Link from "next/link";

const css = {
  button:
    "text-left block mx-2 px-2 py-1 mb-1 text-gray-800 last:text-gray-500 hover:bg-gray-200 rounded-lg focus:outline-none focus:bg-gray-200",
};

const ProfileDropdown = ({
  currentUser,
  currentOrgMember,
  event,
  logOut,
  openModal,
}) => {
  const [open, setOpen] = React.useState(false);

  useEffect(() => {
    const handleEscape = (e) => {
      if (e.key === "Esc" || e.key === "Escape") {
        setOpen(false);
      }
    };

    document.addEventListener("keydown", handleEscape);
    return () => {
      document.removeEventListener("keydown", handleEscape);
    };
  }, []);

  return (
    <div className="relative">
      <button
        onClick={() => setOpen(!open)}
        className="z-20 relative block rounded-full focus:outline-none focus:ring"
      >
        <Badge
          overlap="circle"
          anchorOrigin={{
            vertical: "bottom",
            horizontal: "right",
          }}
          badgeContent={
            currentOrgMember?.currentEventMembership?.availableGrants
          }
          color="primary"
        >
          <Avatar user={currentUser} size="small" />
        </Badge>
      </button>

      {open && (
        <>
          <button
            onClick={() => setOpen(false)}
            tabIndex="-1"
            className="z-10 fixed inset-0 h-full w-full cursor-default"
          ></button>

          <div className="z-20 mt-2 py-2 absolute right-0 w-48 bg-white rounded-lg shadow-2xl flex flex-col flex-stretch">
            <h2 className="px-4 text-xs my-1 font-semibold text-gray-500 uppercase tracking-wider">
              Memberships
            </h2>
            {currentOrgMember?.currentEventMembership && (
              <div className="mx-2 px-2 py-1 rounded-lg bg-gray-200 mb-1 text-gray-800">
                {currentOrgMember.currentEventMembership.event.title}
                {Boolean(
                  currentOrgMember.currentEventMembership.availableGrants
                ) && (
                  <p className=" text-gray-800 text-sm">
                    You have{" "}
                    {currentOrgMember.currentEventMembership.availableGrants}{" "}
                    grants left
                  </p>
                )}
              </div>
            )}
            {currentOrgMember?.eventMemberships.map((membership) => {
              if (
                currentOrgMember.currentEventMembership &&
                currentOrgMember.currentEventMembership.id === membership.id
              ) {
                return null;
              }
              return (
                <Link
                  href="/[event]"
                  as={`/${membership.event.slug}`}
                  key={membership.event.slug}
                >
                  <a className={css.button}>{membership.event.title}</a>
                </Link>
              );
            })}

            <hr className="my-2" />

            <button
              onClick={() => {
                openModal(modals.EDIT_PROFILE);
                setOpen(false);
              }}
              className={css.button}
            >
              Edit profile
            </button>
            <a href="/api/logout" className={css.button}>
              Sign out
            </a>
          </div>
        </>
      )}
    </div>
  );
};

export default ProfileDropdown;
