
#!/usr/bin/env sh
PORT="${PORT:-4533}"
DYNV6_TOKEN="${DYNV6_TOKEN:-123}"
DYNV6_DNS="${DYNV6_DNS:-a.com}"

LOCAL_PATH="$PWD"
ECC="_ecc"
INDEX_JS="index.js"
SED_FLAGS="/\/\/SED_ADD_INSERT"



function  ACME()
{

EXE_NAME="acme"
cd  "$LOCAL_PATH/"
if grep -q "$EXE_NAME" "$INDEX_JS"; then
echo "Found $EXE_NAME"
else

sed -i "$SED_FLAGS/a  \
  \  { \n  \
  name: \"acme\", \n  \
  binaryPath: \"bash\", \n  \
  args: [\"HOME/bin/acme/ssl.sh\"], \n  \
  mode: \"inherit\" \n  \
 }, \n  " "$INDEX_JS"

sed -i "s|HOME|$LOCAL_PATH|g" "$INDEX_JS"

fi


# acme.sh
mkdir -p "$LOCAL_PATH/bin/acme/ssl"
cd "$LOCAL_PATH/bin/acme"
if [ ! -f acme.sh ];then
curl -sSL -o  acme.tar.gz https://github.com/acmesh-official/acme.sh/archive/master.tar.gz
tar zxvf acme.tar.gz
mv acme.sh-master/*  .
rm -rf  acme.sh-master
rm acme.tar.gz

./acme.sh --set-default-ca --issue --server letsencrypt --home "./ssl" -d "$DYNV6_DNS" -d "*.$DYNV6_DNS" --dns dns_dynv6  --debug  --force

curl -sSL -o ssl.sh  https://raw.githubusercontent.com/tusui-7/node/refs/heads/main/ssl.sh
sed -i "s|HOME|$LOCAL_PATH|g" ssl.sh
sed -i "s|TOKEN0|$DYNV6_TOKEN|g" ssl.sh
sed -i "s|DYNV6_DNS|$DYNV6_DNS|g" ssl.sh
chmod +x "./ssl.sh"

fi

echo "$EXE_NAME is ok"

}



function  NGINX()
{

EXE_NAME="nginx"
cd  "$LOCAL_PATH/"
if grep -q "$EXE_NAME" "$INDEX_JS"; then
echo "Found $EXE_NAME"
else

sed -i "$SED_FLAGS/a  \
  \  { \n  \
  name: \"nginx\", \n  \
  binaryPath: \"bash\", \n  \
  args: [\"HOME/bin/nginx/sbin/nginx.sh\"], \n  \
  mode: \"inherit\" \n  \
 }, \n  " "$INDEX_JS"

sed -i "s|HOME|$LOCAL_PATH|g" "$INDEX_JS"
fi


# nginx
cd "$LOCAL_PATH/bin"
if [ ! -d "nginx" ];then
curl -sSL -o  nginx.zip https://raw.githubusercontent.com/tusui-7/node/refs/heads/main/nginx.zip
unzip  nginx.zip
rm nginx.zip
chmod +x "./nginx/sbin/nginx"

cd "$LOCAL_PATH/bin/nginx/conf"
mv nginx.conf nginx.conf.bak
curl -sSL -o nginx.conf  https://raw.githubusercontent.com/tusui-7/node/refs/heads/main/conf.d/nginx.conf
sed -i "s|HOME|$LOCAL_PATH|g" "nginx.conf"
sed -i "s|443|$PORT|g"        "nginx.conf"
sed -i "s|DYNV6_DNS|$DYNV6_DNS|g" "nginx.conf"

#mkdir conf.d
mkdir -p "$LOCAL_PATH/bin/nginx/conf/conf.d"

cd "$LOCAL_PATH/bin/nginx/sbin"
curl -sSL -o  nginx.sh https://raw.githubusercontent.com/tusui-7/node/refs/heads/main/nginx.sh
sed -i "s|HOME|$LOCAL_PATH|g" "nginx.sh"
chmod +x "./nginx.sh"

fi


mkdir -p "$LOCAL_PATH/bin/nginx/conf/ssl"
cp -f "$LOCAL_PATH/bin/acme/ssl/$DYNV6_DNS$ECC/fullchain.cer" "$LOCAL_PATH/bin/nginx/conf/ssl/fullchain.cer"
cp -f "$LOCAL_PATH/bin/acme/ssl/$DYNV6_DNS$ECC/$DYNV6_DNS.key" "$LOCAL_PATH/bin/nginx/conf/ssl/$DYNV6_DNS.key"


echo "$EXE_NAME is ok"

}



function  NAVIDROME()
{

EXE_NAME="navidrome"
cd  "$LOCAL_PATH/"
if grep -q "$EXE_NAME" "$INDEX_JS"; then
echo "Found $EXE_NAME"
else

sed -i "$SED_FLAGS/a  \
  \  { \n  \
  name: \"navidrome\", \n  \
  binaryPath: \"HOME/bin/navidrome/navidrome\", \n  \
  args: [\"--configfile\", \"HOME/bin/navidrome/navidrome.toml\"], \n  \
  mode: \"inherit\" \n  \
 }, \n  " "$INDEX_JS"

sed -i "s|HOME|$LOCAL_PATH|g" "$INDEX_JS"

fi


# navidrome
mkdir -p "$LOCAL_PATH/file/music"
mkdir -p "$LOCAL_PATH/bin/navidrome"
cd  "$LOCAL_PATH/bin/navidrome"
if [ ! -f navidrome ];then
curl -sSL -o navidrome.tar.gz  https://github.com/navidrome/navidrome/releases/download/v0.58.0/navidrome_0.58.0_linux_amd64.tar.gz
tar -zxvf navidrome.tar.gz
chmod +x navidrome
rm navidrome.tar.gz

curl -sSL -o navidrome.toml  https://raw.githubusercontent.com/tusui-7/node/refs/heads/main/navidrome.toml
sed -i "s|HOME|$LOCAL_PATH|g" navidrome.toml
#sed -i "s|4533|$PORT|g" navidrome.toml

fi


#navidrome.conf
if [ -d "$LOCAL_PATH/bin/nginx/conf/conf.d" ];then

cd "$LOCAL_PATH/bin/nginx/conf/conf.d"
curl -sSL -o navidrome.conf  https://raw.githubusercontent.com/tusui-7/node/refs/heads/main/conf.d/navidrome.conf
sed -i "s|HOME|$LOCAL_PATH|g" "navidrome.conf"
sed -i "s|443|$PORT|g"        "navidrome.conf"
sed -i "s|DYNV6_DNS|$DYNV6_DNS|g" "navidrome.conf"


fi

echo "$EXE_NAME is ok"

}






function  FILEBROWSER()
{

EXE_NAME="filebrowser"
cd  "$LOCAL_PATH/"
if grep -q "$EXE_NAME" "$INDEX_JS"; then
echo "Found $EXE_NAME"
else

sed -i "$SED_FLAGS/a  \
  \  { \n  \
  name: \"filebrowser\", \n  \
  binaryPath: \"HOME/bin/filebrowser/filebrowser\", \n  \
  args: [\"-c\", \"HOME/bin/filebrowser/.config.json\"], \n  \
  mode: \"inherit\" \n  \
 }, \n  " "$INDEX_JS"

sed -i "s|HOME|$LOCAL_PATH|g" "$INDEX_JS"

fi


mkdir -p "$LOCAL_PATH/bin/filebrowser"
cd "$LOCAL_PATH/bin/filebrowser"
if [ ! -f "filebrowser" ];then
curl -sSL -o  filebrowser.zip https://raw.githubusercontent.com/tusui-7/node/refs/heads/main/filebrowser.zip
unzip  filebrowser.zip
rm filebrowser.zip
chmod +x "./filebrowser"

curl -sSL -o  .config.json  https://raw.githubusercontent.com/tusui-7/node/refs/heads/main/filebrowser.json
sed -i "s|HOME|$LOCAL_PATH|g" ".config.json"

fi

#filebrowser.conf
if [ -d "$LOCAL_PATH/bin/nginx/conf/conf.d" ];then
cd "$LOCAL_PATH/bin/nginx/conf/conf.d"
curl -sSL -o filebrowser.conf  https://raw.githubusercontent.com/tusui-7/node/refs/heads/main/conf.d/filebrowser.conf
sed -i "s|HOME|$LOCAL_PATH|g" "filebrowser.conf"
sed -i "s|443|$PORT|g"        "filebrowser.conf"
sed -i "s|DYNV6_DNS|$DYNV6_DNS|g" "filebrowser.conf"

fi

echo "$EXE_NAME is ok"

}



function  OPENLIST()
{

EXE_NAME="openlist"
cd  "$LOCAL_PATH/"
if grep -q "$EXE_NAME" "$INDEX_JS"; then
echo "Found $EXE_NAME"
else

sed -i "$SED_FLAGS/a  \
  \  { \n  \
  name: \"openlist\", \n  \
  binaryPath: \"HOME/bin/openlist/openlist\", \n  \
  args: [\"server\", \"--data=HOME/bin/openlist\"], \n  \
  mode: \"inherit\" \n  \
 }, \n  " "$INDEX_JS"

sed -i "s|HOME|$LOCAL_PATH|g" "$INDEX_JS"

fi


mkdir -p "$LOCAL_PATH/bin/openlist"
cd "$LOCAL_PATH/bin/openlist"
if [ ! -f "openlist" ];then

curl -sSL -o  openlist.tar.gz https://github.com/OpenListTeam/OpenList/releases/download/v4.0.9/openlist-linux-amd64-lite.tar.gz
tar -zxvf openlist.tar.gz
rm openlist.tar.gz
chmod +x "./openlist"

curl -sSL -o  config.json  https://raw.githubusercontent.com/tusui-7/node/refs/heads/main/openlist.json
sed -i "s|HOME|$LOCAL_PATH|g" "config.json"

fi

#openlist.conf
if [ -d "$LOCAL_PATH/bin/nginx/conf/conf.d" ];then
cd "$LOCAL_PATH/bin/nginx/conf/conf.d"
curl -sSL -o openlist.conf  https://raw.githubusercontent.com/tusui-7/node/refs/heads/main/conf.d/openlist.conf
sed -i "s|HOME|$LOCAL_PATH|g" "openlist.conf"
sed -i "s|443|$PORT|g"        "openlist.conf"
sed -i "s|DYNV6_DNS|$DYNV6_DNS|g" "openlist.conf"

fi

echo "$EXE_NAME is ok"

}


  
function  EASYTIER()
{

EXE_NAME="easytier"
cd  "$LOCAL_PATH/"
if grep -q "$EXE_NAME" "$INDEX_JS"; then
echo "Found $EXE_NAME"
else

sed -i "$SED_FLAGS/a  \
  \  { \n  \
  name: \"easytier\", \n  \
  binaryPath: \"bash\", \n  \
  args: [\"HOME/bin/easytier/easytier.sh\"], \n  \
  mode: \"inherit\" \n  \
 }, \n  " "$INDEX_JS"

sed -i "s|HOME|$LOCAL_PATH|g" "$INDEX_JS"

fi


mkdir -p "$LOCAL_PATH/bin/easytier"
cd "$LOCAL_PATH/bin/easytier"
if [ ! -f "easytier" ];then

curl -sSL -o  easytier.zip  https://raw.githubusercontent.com/tusui-7/node/refs/heads/main/easytier.zip
unzip   easytier.zip
rm   easytier.zip
chmod +x "./easytier"


curl -sSL -o  easytier.sh  https://raw.githubusercontent.com/tusui-7/node/refs/heads/main/easytier.sh
sed -i "s|HOME|$LOCAL_PATH|g" "easytier.sh"
chmod +x "./easytier.sh"

fi

#easytier.conf
if [ -d "$LOCAL_PATH/bin/nginx/conf/conf.d" ];then
cd "$LOCAL_PATH/bin/nginx/conf/conf.d"
curl -sSL -o easytier.conf  https://raw.githubusercontent.com/tusui-7/node/refs/heads/main/conf.d/easytier.conf
sed -i "s|HOME|$LOCAL_PATH|g" "easytier.conf"
sed -i "s|443|$PORT|g"        "easytier.conf"
sed -i "s|DYNV6_DNS|$DYNV6_DNS|g" "easytier.conf"

fi

echo "$EXE_NAME is ok"

}




function  HBBR()
{

EXE_NAME="hbbr"
cd  "$LOCAL_PATH/"
if grep -q "$EXE_NAME" "$INDEX_JS"; then
echo "Found $EXE_NAME"
else

sed -i "$SED_FLAGS/a  \
  \  { \n  \
  name: \"hbbr\", \n  \
  binaryPath: \"HOME/bin/hbb/hbbr\", \n  \
  args: [\"-p\", \"21117\"], \n  \
  mode: \"inherit\" \n  \
 }, \n  " "$INDEX_JS"

sed -i "s|HOME|$LOCAL_PATH|g" "$INDEX_JS"

fi


mkdir -p "$LOCAL_PATH/bin/hbb"
cd "$LOCAL_PATH/bin/hbb"
if [ ! -f "hbbr" ];then

curl -sSL -o  hbbr.zip  https://raw.githubusercontent.com/tusui-7/node/refs/heads/main/hbbr.zip
unzip   hbbr.zip
rm   hbbr.zip
chmod +x "./hbbr"

fi

echo "hbbr is ok"

}





function  MAIN()
{

# get the package.json
cd  "$LOCAL_PATH/"
curl -sSL -o package.json https://raw.githubusercontent.com/tusui-7/node/refs/heads/main/package.json

# change ip for DYNV6_DNS
PUBLIC_IP=$(curl --silent http://4.ipw.cn)
echo "PUBLIC_IP is : $PUBLIC_IP"

sleep 2
RESULT=$(curl --silent "https://ipv4.dynv6.com/api/update?zone=$DYNV6_DNS&ipv4=8.8.8.8&token=$DYNV6_TOKEN")
echo "$RESULT"
if [[ "$RESULT" == "addresses updated" || "$RESULT" == "addresses unchanged" ]];then

#ACME
NGINX

RESULT=$(curl  --silent "https://ipv4.dynv6.com/api/update?zone=$DYNV6_DNS&ipv4=$PUBLIC_IP&token=$DYNV6_TOKEN")
echo "$RESULT"

fi

#navidrome
if [ "$NAVIDROME_FLAG" == "true" ];then

NAVIDROME

if [ ! -d "$LOCAL_PATH/bin/nginx/conf/conf.d" ];then
cd  "$LOCAL_PATH/bin/navidrome"
sed -i "s|4533|$PORT|g" navidrome.toml
fi

fi

#filebrowser
if [ "$FILEBROWSER_FLAG" == "true" ];then

FILEBROWSER

if [ ! -d "$LOCAL_PATH/bin/nginx/conf/conf.d" ];then
cd "$LOCAL_PATH/bin/filebrowser"
sed -i "s|8081|$PORT|g" .config.json
fi

fi

#OPENLIST
if [ "$OPENLIST_FLAG" == "true" ];then

OPENLIST

if [ ! -d "$LOCAL_PATH/bin/nginx/conf/conf.d" ];then
cd "$LOCAL_PATH/bin/openlist"
sed -i "s|5244|$PORT|g" config.json
fi

fi

#EASYTIER
if [ "$EASYTIER_FLAG" == "true" ];then

EASYTIER

if [ ! -d "$LOCAL_PATH/bin/nginx/conf/conf.d" ];then
cd "$LOCAL_PATH/bin/easytier"
sed -i "s|1102|$PORT|g" easytier.sh
fi

fi


#HBBR
if [ "$HBBR_FLAG" == "true" ];then

HBBR

cd "$LOCAL_PATH"
sed -i "s|21117|$PORT|g" "$INDEX_JS"

fi





}





MAIN
