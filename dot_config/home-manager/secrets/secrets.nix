let
  crows = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDtCexKt2ykvp2sbhMhaW2ApbT8nuD9lHeTHFPqknJcZ";
  all = [ crows ];
in
{
  "go_private_on_working.fish".publicKeys = all;
}
