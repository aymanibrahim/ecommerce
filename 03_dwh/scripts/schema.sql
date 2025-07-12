-- Create Dimension table DimDate
CREATE TABLE IF NOT EXISTS public."DimDate" (
    dateid          INTEGER     PRIMARY KEY,
    date            DATE        NOT NULL,
    "Year"          INTEGER     NOT NULL,
    "Quarter"       INTEGER     NOT NULL,
    "QuarterName"   VARCHAR(50) NOT NULL,
    "Month"         INTEGER     NOT NULL,
    "Monthname"     VARCHAR(50) NOT NULL,
    "Day"           INTEGER     NOT NULL,
    "Weekday"       INTEGER     NOT NULL,
    "WeekdayName"   VARCHAR(50) NOT NULL
);

-- Create Dimension table DimCategory
CREATE TABLE IF NOT EXISTS public."DimCategory" (
    categoryid  INTEGER     PRIMARY KEY,
    category    VARCHAR(50) NOT NULL
);

-- Create Dimension table DimCountry
CREATE TABLE IF NOT EXISTS public."DimCountry" (
    countryid   INTEGER     PRIMARY KEY,
    country     VARCHAR(50) NOT NULL
);

-- Create Fact table FactSales
CREATE TABLE IF NOT EXISTS public."FactSales" (
    orderid     INTEGER PRIMARY KEY,
    dateid      INTEGER NOT NULL,
    countryid   INTEGER NOT NULL,
    categoryid  INTEGER NOT NULL,
    amount      INTEGER NOT NULL,
    FOREIGN KEY (dateid)        REFERENCES public."DimDate"(dateid),
    FOREIGN KEY (countryid)     REFERENCES public."DimCountry"(countryid),
    FOREIGN KEY (categoryid)    REFERENCES public."DimCategory"(categoryid)
);
