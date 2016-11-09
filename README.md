


git clone https://github.com/AmirkhajehB/pm-resan.git

بسته های زیر نصب شوند

sudo apt-get update
sudo apt-get install lua5.1 luarocks lua-socket lua-sec redis-server curl 
sudo luarocks install oauth 
sudo luarocks install redis-lua 
sudo luarocks install lua-cjson 
sudo luarocks install ansicolors 
sudo luarocks install serpent

و در اخر

screen lua bot.lua
