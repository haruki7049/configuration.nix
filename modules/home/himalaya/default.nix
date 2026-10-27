{
  ...
}:

{
  programs.himalaya.enable = true;

  accounts.email.accounts."haruki7049" = {
    primary = true;
    address = "haruki7049@mail.haruki7049.dev";
    userName = "haruki7049@mail.haruki7049.dev";
    realName = "haruki7049";

    imap = {
      host = "mail.haruki7049.dev";
      authentication = "plain";
    };
    smtp = {
      host = "mail.haruki7049.dev";
      authentication = "plain";
    };

    himalaya.enable = true;

    # passwordCommand is not set yet: the password is meant to come from sops, which is not set up.
  };
}
