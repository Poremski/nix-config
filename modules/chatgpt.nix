{ pkgsUnstable, ... }:

{
  environment.systemPackages = [
    pkgsUnstable.chatgpt
  ];
}
