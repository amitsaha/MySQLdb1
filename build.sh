docker run --rm -v `pwd`/mysql-5.1.51:/mysql-5.1.51 -v `pwd`:/workspace:z quay.io/pypa/manylinux1_x86_64  /workspace/build-manylinux1-wheels.sh
