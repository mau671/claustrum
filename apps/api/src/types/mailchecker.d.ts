declare module "mailchecker" {
  const MailChecker: {
    isValid: (email: string) => boolean;
    blacklist: () => string[];
  };
  export default MailChecker;
}
