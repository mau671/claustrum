import type { SVGProps } from "react";

const GoogleDocs = (props: SVGProps<SVGSVGElement>) => (
  <svg {...props} viewBox="0 0 24 24" fill="none">
    <path
      d="M14.727 6.727H14V0H4.91c-.905 0-1.637.732-1.637 1.636v20.728c0 .904.732 1.636 1.636 1.636h14.182c.904 0 1.636-.732 1.636-1.636V6.727h-6Z"
      fill="#4285F4"
    />
    <path d="m14.727 6 6 .001L14.727 0v6Z" fill="#A1C2FA" />
    <path
      d="M7.091 17.182h9.818v-1.364H7.091v1.364Zm0-3.273h9.818V12.545H7.091v1.364Zm0-3.273h9.818V9.273H7.091v1.363Z"
      fill="white"
    />
  </svg>
);

export { GoogleDocs };
