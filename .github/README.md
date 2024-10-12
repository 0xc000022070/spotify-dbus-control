
# Spotify DBUS Control

## How? (NixOS)

1. First add the flake to your NixOS configuration:

```nix

inputs = {
  spotify-dbus-control = {
     url = "github:0xc000022070/spotify-dbus-control";
     # optional
     inputs = {
       nixpkgs.follows = "nixpkgs";
       flake-utils.follows = "flake-utils";
     };
   };
  ...
}
```

2. Integrate it with your own window manager (I'm using Hyprland in this example).

![image](https://github.com/user-attachments/assets/094848f7-dbcc-4a36-ba13-50fabbd7627d)


## CLI Reference

```text
spotify-dbus <flag>

Flags:
 --next            Go to the next song
 --prev            Go to the previous song
 --toggle          Play or pause the current song
 --push-back       Go back 5 seconds
 --push-forward    Go forward 5 seconds
 --stop            Just stop
```

## License

[MIT](./LICENSE)
