{ config, pkgs, libs, ... }:
let
  one-password-id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";
  adblock-id = "gighmmpiobklfepjocnamgkkbiglidom";
  dark-reader-id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
  vimium-id = "dbepggeogbaibhgnhhndojpepiihcmeb";
  octotree-id = "bkhaagjahfmjljalopjnoealnfndnagc";
  plasma-integration-id = "cimiefiiaegbelhefglklhhakcgmhkai";
  keepa-id = "neebplgakaahbhdphmkckjjcegoiijjo"; # Amazon price tracker
  tosdr-id = "hjdoplcnndgiblooccencgcggcoihigg"; # Terms of Service; Didn't read
  grammerly-id = "kbfnbcaeplbcioakkpcpgfkobkghlhen";
  return-youtube-dislikes = "gebbhagfogifgggkldgodflihgfeippi";
  pocket-tube-id = "kdmnjgijlmjgmimahnillepgcgeemffb"; # Youtube subscription manager
in
{
  home.packages = with pkgs; [
    google-chrome
  ];

  programs.chromium = {
    enable = true;
    extensions = [
      { id = one-password-id; }
      { id = adblock-id; }
      { id = dark-reader-id; }
      { id = vimium-id; }
      { id = octotree-id; }
      { id = plasma-integration-id; }
      { id = keepa-id; }
      { id = tosdr-id; }
      { id = grammerly-id; }
      { id = return-youtube-dislikes; }
      { id = pocket-tube-id; }
    ];
  };
}
