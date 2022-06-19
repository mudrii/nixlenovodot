{ config, lib, pkgs, ... }:

let
  unstable = import <unstable> {
    config.allowUnfree = true;
  };
in

{
  home = {
    packages = with pkgs; [
      unstable.bpytop
      unstable.glances
      neofetch
      poppler_utils
      elinks
      w3m
      ffmpeg-full
      ffmpegthumbnailer
      exif
      exiftool
      mupdf
      screen
      keychain
      unstable.minio-client
      google-cloud-sdk-gce
      unstable.awscli
     # unstable.clojure
     # clojure-lsp
     # pulumi-bin
     # unstable.pulumi-bin
      unstable.gitAndTools.gitFull
      unstable.gitAndTools.gh
      unstable.git-crypt
      unstable.git-lfs
      unstable.terraform
      unstable.terraform-lsp
      unstable.tflint
      unstable.kubernetes
      unstable.kubernetes-helm
     # unstable.kubeseal
     # unstable.helmfile
     # unstable.helmsman
     # unstable.kind
     # unstable.kube3d
     # unstable.skopeo
     # unstable.dive
     # unstable.lens
     # unstable.docker-machine-kvm2
     # unstable.minikube
     # unstable.fluxctl
     # unstable.argo
     # unstable.argocd
     # unstable.kustomize
     # unstable.k9s
     # unstable.velero
     # unstable.go
     # unstable.xmind
     # teams
      signal-desktop
     # kubectx
      dep
      /*
      (unstable.terraform.withPlugins(p: with p; [
        archive
        aws
        external
        google
        helm
        kubernetes
        local
        null
        random
        template
      ]))
        */
      # (lowPrio unstable.python39Full)
      # python3Full
      # python39Full
      # python39Packages.poetry
      # unstable.python38Packages.pynvim
      poetry
      (
        python39.withPackages (
          ps: with ps; [
            #poetry
            pip
            powerline
            pygments
            yubico-client
            pygments-markdown-lexer
            xstatic-pygments
            # pylint
            # pandas
            # pycuda
            # numpy
            # opencv4
            # scipy
            # matplotlib
            # jupyter
            pynvim
            pyopenssl
          ]
        )
      )
      aspell
      aspellDicts.en
      asciinema
      unstable.direnv
      psensor
      thunderbird
      # libreoffice
      onlyoffice-bin
      qutebrowser
      bitwarden
      bitwarden-cli
      shotcut
      # unstable.amfora
      unstable.lagrange
      unstable.vscode
      # vscodium
      unstable.sublime4
      unstable.sublime-merge
      # unstable.insomnia
      slack
      vlc
      gpicview
      ripgrep
      ripgrep-all
      tldr
      procs
      fd
      # zathura
      mpv
      pv
      feh
      # weechat
      gcc
      gnumake
      gnupg
      pinentry-curses
      pinentry-qt
      paperkey
      pam_u2f
      libu2f-host
      libu2f-server
      gpa
      imagemagick
      spotify
      bookworm
      ltrace
      /*
        (unstable.tor-browser-bundle-bin.override {
        mediaSupport = true;
        pulseaudioSupport = true;
        })
      */
      unstable.keepassxc
      openconnect_openssl
      networkmanager-openconnect
      unstable.element-desktop
      unstable.ansible
      graphviz
      scrcpy
      unstable.pcmanfm
      mucommander
      unstable.hexchat
      unstable.grsync
      unstable.luckybackup
      unstable.drawio
      unstable.youtube-dl
      yubikey-manager
      yubico-piv-tool
      yubikey-manager-qt
      yubikey-personalization
      yubikey-personalization-gui
      yubioath-desktop
      yubico-pam
      monero
      monero-gui
      unstable.xmrig
      unstable.xmr-stak
      unstable.ledger
      unstable.ledger-web
      unstable.ledger-live-desktop
      unstable.audacity
      unstable.nodejs
      unicode-paracode
      system-config-printer
      play-with-mpv
      jetbrains.idea-ultimate
      viber
    ];
  };
}

