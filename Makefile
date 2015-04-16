# sybase
# trade:base
#   +- trade:db
#     +- trade:build
#     +- trade
# arch-dlin
srv=192.168.67.23:5000

all: sybase.tag trade-build.tag trade.tag build-dlin.tag

clean:
	rm -f *.tag

sybase.tag: sybase/Dockerfile sybase/sybase157.min.txz
	cd sybase ; docker build -t sybase .
	-docker rmi -f ${srv}/sybase
	docker tag -f sybase ${srv}/sybase
	touch sybase.tag

pull.tag: trade-base/Dockerfile
	cd trade-base ; docker build -t trade:base --no-cache --pull .
	touch pull.tag
	touch trade-base.tag
trade-base.tag: trade-base/Dockerfile trade-base/rsyslog.conf
	cd trade-base ; docker build -t trade:base .
	touch trade-base.tag
trade-db.tag: trade-base.tag trade-db/Dockerfile trade-db/rc.sybase \
		trade-db/test_sql.sh trade-db/sybase157.min.txz
	cd trade-db ; docker build -t trade:db .
	-docker rmi -f ${srv}/trade:db
	docker tag -f trade:db ${srv}/trade:db
	touch trade-db.tag
trade-build.tag: trade-db.tag trade-build/Dockerfile \
		trade-build/matlab_2010a.min.txz
	cd trade-build ; docker build -t trade:build .
	-docker rmi -f ${srv}/trade:build
	docker tag -f trade:build ${srv}/trade:build
	touch trade-build.tag
update.tag:
	cd trade ; ./update_tgz.sh
	touch update.tag
trade.tag: update.tag trade-db.tag trade/Dockerfile
	cd trade ; docker build -t trade .
	-docker rmi -f ${srv}/trade
	docker tag -f trade ${srv}/trade
	touch trade.tag

build-dlin.tag: trade-build.tag build-dlin/Dockerfile
	cd build-dlin ; docker build -t build-dlin .
	touch build-dlin.tag

arch-dlin.tag: arch-dlin/Dockerfile
	cd arch-dlin ; docker build -t arch-dlin .
	touch arch-dlin.tag

# for chewen
txz:
	tar cJf src.txz trade-base/Dockerfile trade-base/rsyslog.conf \
		trade/Dockerfile trade/rsh trade/trade_profile.sh
push: trade.push.tag trade-build.push.tag trade-db.push.tag
trade.push.tag: trade.tag
	docker push ${srv}/trade
	touch trade.push.tag
trade-build.push.tag: trade-build.tag
	docker push ${srv}/trade:build
	touch trade-build.push.tag
trade-db.push.tag: trade-db.tag
	docker push ${srv}/trade:db
	touch trade-db.push.tag

# maybe require root to execute
matlab.txz:
	tar -C/ -cJf matlab.txz \
		usr/local/MATLAB/R2010a/runtime \
		usr/local/MATLAB/R2010a/extern/include \
		usr/local/MATLAB/R2010a/extern/lib
llm.txz:
	tar -C/ -cJf llm.txz \
		opt/IBM/llm \
		opt/IBM/llm2607_fix4/lib64 \
		opt/IBM/llm2607_fix4/version.properties \
		opt/IBM/llm2607_fix4/include
tsa.txz:
	tar -C/ -cJf tsa.txz \
		opt/tsa

sybase.txz:
	tar -C/ -cJf sybase.txz \
		sybase
