# if you edit the line below, be sure to insert tabs, but not spaces, in-between key-value pairs in brackets
# once again, to modify the subsequent line, turn off the freaking "convert tabs to spaces" setting in your editor
set -o verbose
sudo-gconftool-2 --type list --list-type string --set /desktop/gnome/peripherals/keyboard/kbd/options "[terminate	terminate:ctrl_alt_bksp,grp	grp:alt_shift_toggle,ctrl	ctrl:nocaps]"
set +o verbose

