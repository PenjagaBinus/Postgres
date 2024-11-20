Soal #3
CREATE TABLE mahasiswa(
	user_id integer PRIMARY KEY AUTO INCREMENT,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) DEFAULT NULL,
	email VARCHAR(355) UNIQUE NOT NULL,
	age integer DEFAULT 18,
	gender VARCHAR(50) CHECK(gender = 'male' OR 'female'),
	date_of_birth DATE NOT NULL,
	created_at TIMESTAMP DEFAULT NOW()
);

#Soal 4
create or replace function Genres_Find(gen varchar)
 RETURNS TABLE(
 mov_title character varying(60))
 AS $$
 BEGIN
 RETURN QUERY
 SELECT movie.mov_title FROM movie
 INNER JOIN movie_genres ON movie_genres.mov_id = movie.mov_id
 INNER JOIN genres ON movie_genres.gen_id = genres.gen_id
 WHERE genres.gen_title = gen;
 END;
 $$ LANGUAGE plpgsql;

#Soal 5

#a Tanpa index
explain select nama,desa FROM ninja where email LIKE 'sakura%';

#b
explain select nama,desa FROM ninja where email LIKE 'sakura%';
set enable_seqscan = off;
create index sakura on ninja(email);
explain select nama,desa FROM ninja where email LIKE 'sakura%';

Soal #6
SELECT genres.gen_title, rating.rev_stars, RANK() OVER(
PARTITION BY genres.gen_title
ORDER BY rating.rev_stars DESC) AS ranked_genres
FROM genres
INNER JOIN movie_genres ON genres.gen_id = movie_genres.gen_id
INNER JOIN movie ON movie_genres.mov_id = movie.mov_id
INNER JOIN rating ON movie.mov_id = rating.mov_id
GROUP BY genres.gen_title, rating.rev_stars;

Soal #7
SELECT CONCAT(director.dir_fname,' ',director.dir_lname) AS director_name, mov_title FROM director
INNER JOIN movie_direction ON movie_direction.dir_id = director.dir_id
INNER JOIN movie ON movie_direction.mov_id = movie.mov_id
WHERE director.dir_fname = 'James' AND director.dir_lname = 'Cameron';

Soal #8
SELECT actor.act_fname AS people FROM actor
UNION
SELECT director.dir_fname FROM director;

Soal #9
SELECT genres.gen_title, COUNT(genres.gen_title) AS number_of_movies FROM genres
INNER JOIN movie_genres ON movie_genres.gen_id = genres.gen_id
INNER JOIN movie ON movie_genres.mov_id = movie.mov_id
GROUP BY genres.gen_title
HAVING genres.gen_title IN('Mystery','Drama','Adventure');

Soal #10
 WITH labels AS (
 SELECT
        CASE
        WHEN mov_time < 100 THEN 'short movie'
        WHEN mov_time > 130 THEN 'long movie'
        WHEN mov_time BETWEEN 100 AND 130 THEN 'normal movie'
        END AS label_duration FROM movie
 )
 SELECT labels.label_duration,COUNT(labels.label_duration) AS number_of_movies
 FROM labels
 GROUP BY labels.label_duration;