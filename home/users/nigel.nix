let
  username = "nigel";
in
{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
}
