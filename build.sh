cd ~/
rm -rf nginquic
curl -sSL https://raw.githubusercontent.com/minoplhy/nginquic/main/packages.sh | bash
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
cd nginx-quic
mkdir mosc && cd mosc && curl -sSL https://raw.githubusercontent.com/minoplhy/nginquic/main/modules.sh | bash && cd ..
curl -sSL https://raw.githubusercontent.com/minoplhy/nginquic/main/configure.sh | bash && make
mkdir /lib/nginx/ && mkdir /lib/nginx/modules
cd objs && cp *.so /lib/nginx/modules
rm /usr/sbin/nginx
cp nginx /usr/sbin/nginx
curl -sSL https://raw.githubusercontent.com/minoplhy/nginquic/main/modules.conf > modules.conf
cp modules.conf /etc/nginx/modules-enabled