-- Set defaults
USE WAREHOUSE COMPUTE_WH;
USE DATABASE MOVIELENS;
USE SCHEMA RAW;

CREATE STAGE movielensstage
  URL='s3://<your_s3_bucket>'
  CREDENTIALS=(AWS_KEY_ID='...' AWS_SECRET_KEY='...');
  
-- Load raw_movies
CREATE OR REPLACE TABLE raw_movies (
  movieId INTEGER,
  title STRING,
  genres STRING
);

COPY INTO raw_movies
FROM '@movielensstage/movies.csv'
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- Load raw_ratings
CREATE OR REPLACE TABLE raw_ratings (
  userId INTEGER,
  movieId INTEGER,
  rating FLOAT,
  timestamp BIGINT
);

COPY INTO raw_ratings
FROM '@movielensstage/ratings.csv'
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- Load raw_tags
CREATE OR REPLACE TABLE raw_tags (
  userId INTEGER,
  movieId INTEGER,
  tag STRING,
  timestamp BIGINT
);

COPY INTO raw_tags
FROM '@movielensstage/tags.csv'
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"')
ON_ERROR = 'CONTINUE';

-- Load raw_genome_scores
CREATE OR REPLACE TABLE raw_genome_scores (
  movieId INTEGER,
  tagId INTEGER,
  relevance FLOAT
);

COPY INTO raw_genome_scores
FROM '@movielensstage/genome-scores.csv'
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- Load raw_genome_tags
CREATE OR REPLACE TABLE raw_genome_tags (
  tagId INTEGER,
  tag STRING
);

COPY INTO raw_genome_tags
FROM '@movielensstage/genome-tags.csv'
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- Load raw_links
CREATE OR REPLACE TABLE raw_links (
  movieId INTEGER,
  imdbId INTEGER,
  tmdbId INTEGER
);

COPY INTO raw_links
FROM '@movielensstage/links.csv'
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');


