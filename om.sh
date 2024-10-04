#!/usr/bin/env bash

# check if the user is on NixOS
if [ -n "$(grep -i nixos < /etc/os-release)" ]; then
  echo "deez" > /dev/null
else
  echo "This is not NixOS or the distribution information is not available; this installation script only works for NixOS."
  exit
fi

if command -v git &> /dev/null; then
  echo "nuts" > /dev/null
else
  nix-shell -p git
fi


# clone orxngc/dots in $HOME
cd $HOME || exit
# echo "Cloning repository..."
# git clone https://github.com/omsenjalia/dots
# echo "orxngc/dots cloned successfully."
cd $HOME/dots
# Ask the user for their username & hostname
# read -p "Enter your username: " username
# sed -i 's/\(username = "\)[^"]*\(".*\)/\1'$username'\2/' flake.nix
 read -p "Enter your hostname: " hostname
# cp -r $HOME/dots/hosts/default "$HOME/dots/hosts/$hostname"
# sed -i 's/\(host = "\)[^"]*\(".*\)/\1'$hostname'\2/' flake.nix

# Copy the hyprpanel config
# cp $HOME/dots/files/hyprpanel.json $HOME/.cache/ags/hyprpanel/options.json

# Prompt the user for wallpaper repositories
# echo "Choose wallpaper repositories to install:"
# echo "1) https://github.com/orxngc/walls"
# echo "2) https://github.com/orxngc/walls-catppuccin-mocha"
# echo "3) Other (enter URL)"
# echo "4) None"
# echo "Warning: You can only use one wallpaper repository at a time."
# read -p "Enter your choice (comma-separated for multiple options): " choice

# cd $HOME/media || exit
# IFS=',' read -ra ADDR <<< "$choice"
# for i in "${ADDR[@]}"; do
  #  case $i in
   #     1)
    #        git clone https://github.com/orxngc/walls
     #       sed -i "s/walls/walls/g" "$HOME/dots/scripts/walls.nix"
      #      ;;
       # 2)
        #    git clone https://github.com/orxngc/walls-catppuccin-mocha
         #   echo "yes" # sed -i "s/
          857|       if isDefined then

          858|         if all (def: type.check def.value) defsFinal then type.merge loc defsFinal

             |                      ^

          859|         else let allInvalid = filter (def: ! type.check def.value) defsFinal;


       … while calling 'check'


         at /nix/store/r2hk87rfvc5fpfbl2bj64a3x7mcq9f6c-source/lib/types.nix:528:15:


          527|       descriptionClass = "noun";

          528|       check = x: isStringLike x && builtins.substring 0 1 (toString x) == "/";

             |               ^

          529|       merge = mergeEqualOption;


       … while evaluating derivation 'dbus-1'

         whose name attribute is located at /nix/store/r2hk87rfvc5fpfbl2bj64a3x7mcq9f6c-source/pkgs/stdenv/generic/make-derivation.nix:336:7


       … while evaluating attribute 'serviceDirectories' of derivation 'dbus-1'


         at /nix/store/r2hk87rfvc5fpfbl2bj64a3x7mcq9f6c-source/pkgs/development/libraries/dbus/make-dbus-conf.nix:17:12:


           16|   {

           17|     inherit serviceDirectories suidHelper apparmor;

             |            ^

           18|     preferLocalBuild = true;


       … while calling anonymous lambda


         at /nix/store/r2hk87rfvc5fpfbl2bj64a3x7mcq9f6c-source/lib/types.nix:546:14:


          545|       merge = loc: defs:

          546|         map (x: x.value) (filter (x: x ? value) (concatLists (imap1 (n: def:

             |              ^

          547|           imap1 (m: def':


       … while calling anonymous lambda


         at /nix/store/r2hk87rfvc5fpfbl2bj64a3x7mcq9f6c-source/lib/modules.nix:858:17:


          857|       if isDefined then

          858|         if all (def: type.check def.value) defsFinal then type.merge loc defsFinal

             |                 ^

          859|         else let allInvalid = filter (def: ! type.check def.value) defsFinal;


       … from call site


         at /nix/store/r2hk87rfvc5fpfbl2bj64a3x7mcq9f6c-source/lib/modules.nix:858:22:


          857|       if isDefined then

          858|         if all (def: type.check def.value) defsFinal then type.merge loc defsFinal

             |                      ^

          859|         else let allInvalid = filter (def: ! type.check def.value) defsFinal;


       … while calling 'check'


         at /nix/store/r2hk87rfvc5fpfbl2bj64a3x7mcq9f6c-source/lib/types.nix:528:15:


          527|       descriptionClass = "noun";

          528|       check = x: isStringLike x && builtins.substring 0 1 (toString x) == "/";

             |               ^

          529|       merge = mergeEqualOption;


       … while evaluating derivation 'system-path'

         whose name attribute is located at /nix/store/r2hk87rfvc5fpfbl2bj64a3x7mcq9f6c-source/pkgs/stdenv/generic/make-derivation.nix:336:7


       … while evaluating attribute 'passAsFile' of derivation 'system-path'


         at /nix/store/r2hk87rfvc5fpfbl2bj64a3x7mcq9f6c-source/pkgs/build-support/trivial-builders/default.nix:60:9:


           59|         inherit buildCommand name;

           60|         passAsFile = [ "buildCommand" ]

             |         ^

           61|           ++ (derivationArgs.passAsFile or [ ]);


       … while calling anonymous lambda


         at /nix/store/r2hk87rfvc5fpfbl2bj64a3x7mcq9f6c-source/lib/attrsets.nix:1205:18:


         1204|         mapAttrs

         1205|           (name: value:

             |                  ^

         1206|             if isAttrs value && cond value


       … from call site


         at /nix/store/r2hk87rfvc5fpfbl2bj64a3x7mcq9f6c-source/lib/attrsets.nix:1208:18:


         1207|             then recurse (path ++ [ name ]) value

         1208|             else f (path ++ [ name ]) value);

             |                  ^

         1209|     in


       … while calling anonymous lambda


         at /nix/store/r2hk87rfvc5fpfbl2bj64a3x7mcq9f6c-source/lib/modules.nix:254:72:


          253|           # For definitions that have an associated option

          254|           declaredConfig = mapAttrsRecursiveCond (v: ! isOption v) (_: v: v.value) options;

             |                                                                        ^

          255|


       … while evaluating the option `environment.systemPackages':


       … from call site


         at /nix/store/r2hk87rfvc5fpfbl2bj64a3x7mcq9f6c-source/lib/modules.nix:858:59:


          857|       if isDefined then

          858|         if all (def: type.check def.value) defsFinal then type.merge loc defsFinal

             |                                                           ^

          859|         else let allInvalid = filter (def: ! type.check def.value) defsFinal;


       … while calling 'merge'


         at /nix/store/r2hk87rfvc5fpfbl2bj64a3x7mcq9f6c-source/lib/types.nix:545:20:


          544|       check = isList;

          545|       merge = loc: defs:

             |                    ^

          546|         map (x: x.value) (filter (x: x ? value) (concatLists (imap1 (n: def:


       … while calling anonymous lambda


         at /nix/store/r2hk87rfvc5fpfbl2bj64a3x7mcq9f6c-source/lib/types.nix:546:35:


          545|       merge = loc: defs:

          546|         map (x: x.value) (filter (x: x ? value) (concatLists (imap1 (n: def:

             |                                   ^

          547|           imap1 (m: def':


       … while calling anonymous lambda


         at /nix/store/r2hk87rfvc5fpfbl2bj64a3x7mcq9f6c-source/lib/lists.nix:334:29:


          333|   */

          334|   imap1 = f: list: genList (n: f (n + 1) (elemAt list n)) (length list);

             |                             ^

          335|


       … from call site


         at /nix/store/r2hk87rfvc5fpfbl2bj64a3x7mcq9f6c-source/lib/lists.nix:334:32:


          333|   */

          334|   imap1 = f: list: genList (n: f (n + 1) (elemAt list n)) (length list);

             |                                ^

          335|walls/walls-catppuccin-mocha/g" "$HOME/dots/scripts/walls.nix"
          #  ;;
       # 3)
        #    read -p "Enter the URL of the wallpaper repository: " repo_url
         #   repo_name=$(basename "$repo_url" .git)
          #  git clone "$repo_url"
           # sed -i "s/walls/$repo_name/g" "$HOME/dots/scripts/walls.nix"
            #;;
       # 4)
        #    echo "Warning: No wallpaper repository selected. Wallpapers will be broken unless you put images into $username/media/walls."
         #   ;;
        # *)
          #  echo "Invalid choice: $i"
           # ;;
    # esac
# done
cd dots
# Generate hardware config
echo "Generating hardware configuration..."
nixos-generate-config --show-hardware-config > "$HOME/dots/hosts/$hostname/hardware.nix"
echo "Hardware configuration successfully generated."

# Set NIX_CONFIG
export NIX_CONFIG="experimental-features = nix-command flakes"
echo "Enabled flakes."

# Ask for git username and email, and replace them in variables.nix
# read -p "Enter your git username: " git_username
# read -p "Enter your git email: " git_email
# sed -i "s/gitUsername = \"orxngc\";/gitUsername = \"$git_username\";/g" "$HOME/dots/hm-modules/core/boilerplate.nix"
# sed -i "s/gitEmail = \"orangc@proton.me\";/gitEmail = \"$git_email\";/g" "$HOME/dots/hm-modules/core/boilerplate.nix"

# Rebuild the system with the specified hostname
echo "Rebuilding system..."
cd $HOME/dots
git add .
git commit -m "Git sync"
echo $hostname
nix flake show ".#$hostname"
sudo nixos-rebuild boot --flake ".#$hostname" --show-trace
home-manager switch --flake /home/om/dots
echo "System successfully rebuilt."
# echo " IMPORTANT: reboot your system now for the changes to take effect."
# echo "Have fun with my dots! —orangc"
