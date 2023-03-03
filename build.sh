cd ~/
rm -rf nginquic
curl -sSL https://raw.githubusercontent.com/minoplhy/nginquic/ModSecurity_incl/packages.sh | bash
mkdir nginquic && cd nginquic

# Install Golang
unlink /usr/bin/go
wget https://go.dev/dl/go1.19.3.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.3.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
ln -s /usr/local/go/bin /usr/bin/go

hg clone -b quic https://hg.nginx.org/nginx-quic
git clone --depth=1 https://github.com/google/boringssl
cd boringssl
mkdir build && cd build && cmake .. && make
cd .. && cd ..

# ModSecurity Part
git clone --depth=1 https://github.com/SpiderLabs/ModSecurity
cd ModSecurity/
git submodule init
git submodule update
./build.sh
./configure
make
sudo make install
cd ..

cd nginx-quic
mkdir mosc && cd mosc && curl -sSL https://raw.githubusercontent.com/minoplhy/nginquic/ModSecurity_incl/modules.sh | bash && cd ..
curl -sSL https://raw.githubusercontent.com/minoplhy/nginquic/ModSecurity_incl/configure.sh | bash && make

read -p "Would you like to Install Nginx Scriptly? (y/n)?" choice
case "$choice" in 
  y|Y ) Nginx_Install_ANS="install";;
  n|N ) Nginx_Install_ANS="no";;
  * ) Nginx_Install_ANS="abort";;
esac

if [[ $Nginx_Install_ANS == "install" ]]; then
    mkdir /lib/nginx/ && mkdir /lib/nginx/modules
    cd objs && cp *.so /lib/nginx/modules
    rm /usr/sbin/nginx
    cp nginx /usr/sbin/nginx
    curl -sSL https://raw.githubusercontent.com/minoplhy/nginquic/ModSecurity_incl/modules.conf > modules.conf
    cp modules.conf /etc/nginx/modules-enabled
else
    echo "Nginx Installation Abort. Your Nginx assets location is : ~/nginquic/nginx-quic/objs"
fi