pip install psycopg2-binary

docker run -d --name postgres -p 5432:5432 postgres
sleep 5
cat /Users/vivek/Desktop/DataWarehousing/week1.sql | docker run --net host -i postgres psql --host 0.0.0.0 --user postgres
python /Users/vivek/Desktop/DataWarehousing/week1.py

cat tables.sql | docker run --net host -i postgres psql --host 0.0.0.0 --user postgres
python week2.py

cat queries.sql | docker run --net host -i postgres psql --host 0.0.0.0 --user postgres
