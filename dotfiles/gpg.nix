{ config, pkgs, lib, ... }:

{
  home-manager.users.mudrii = {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 60;
      maxCacheTtl = 120;
      pinentryFlavor = "curses";
      verbose = true;
    };
    programs.gpg = {
      enable = true;
      settings = {
        personal-cipher-preferences = "AES256";
        personal-digest-preferences = "SHA512";
        personal-compress-preferences = "ZLIB";
        default-preference-list = "SHA512";
        cert-digest-algo = "SHA512";
        s2k-digest-algo = "SHA512";
        s2k-cipher-algo = "AES256";
        charset = "utf-8";
        fixed-list-mode = true;
        no-comments = true;
        no-emit-version = true;
        no-greeting = true;
        keyid-format = "0xlong";
        list-options = "show-uid-validity";
        verify-options = "show-uid-validity";
        with-fingerprint = true;
        require-cross-certification = true;
        no-symkey-cache = true;
        use-agent = true;
        throw-keyids = true;
      };
    };
  };
}
