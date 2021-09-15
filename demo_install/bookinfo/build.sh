
git clone https://github.com/pirsoscom/bookinfo.git
cd bookinfo/

cd productpage
docker build -t niklaushirt/bookinfo-productpage-v1:log .
docker push niklaushirt/bookinfo-productpage-v1:log
cd ..


cd details
docker build -t niklaushirt/bookinfo-details-v1:log .
docker push niklaushirt/bookinfo-details-v1:log
cd ..


cd reviews
gradle build
cd reviews-wlpcfg
docker build -t niklaushirt/bookinfo-reviews-v2:log .
docker push niklaushirt/bookinfo-reviews-v2:log
cd ../..


cd ratings
docker build -t niklaushirt/bookinfo-ratings-v1:log .
docker push niklaushirt/bookinfo-ratings-v1:log
cd ..


cd productpage/
docker build -t niklaushirt/productpage:log .
docker push niklaushirt/productpage:log
cd ..





