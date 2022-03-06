# Elden Ring Launcher

## What is it

This is a wrapper script that provides a workaround for a known issue with running the game Elden Ring via Steam/Proton on Linux.

## Is this official

Nope, I'm not affiliated with Elden Ring or Steam or anything.

## What does it do

Elden Ring uses Easy Anti-Cheat. An unfortunate side-effect of this is that if you have any network interfaces up when the game launches, it will crash. So this script provides a simple workaround: kill all network interfaces, then launch the game, then bring the interfaces back up again after a few seconds.

## How do I use it

1. Download the file [eldenringlauncher.sh](eldenringlauncher.sh) from this repository and save it somewhere on your computer
2. Go to your Steam library, right-click on Elden Ring, go to Properties -> General -> Launch Options
3. Enter the full path to the script, followed by %command%. Example: `/home/user/launcher.sh %command%`. Steam saves this setting so you don't have to re-enter it each time you want to play.
4. Launch Elden Ring through Steam normally
