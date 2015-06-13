{-# LANGUAGE OverloadedStrings #-}

-- Dependencies
-- postgresql-simple

import Control.Monad
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow

hello :: IO Int
hello = do
  conn <- connectPostgreSQL ""
  [Only i] <- query_ conn "select 2 + 2"
  return i

type Name = String
type Price = Int
data Product = Product Name Price deriving (Show)

instance FromRow Product where 
    fromRow = Product <$> field <*> field

createProductsTable :: IO ()
createProductsTable = do
  conn <- connect defaultConnectInfo { 
    connectPassword = "",
    connectDatabase = "pet_store",
    connectUser = "jleakakos"
    }
  execute_ conn "create table products (name text, price int)"
  return ()

insertProduct :: Product -> IO ()
insertProduct (Product name price) = do
  conn <- connect defaultConnectInfo { 
    connectPassword = "",
    connectDatabase = "pet_store",
    connectUser = "jleakakos"
    }
  execute conn "insert into products values (?, ?)" (name, price)
  return ()

insertProductFromData :: Name -> Price -> IO ()
insertProductFromData name price = insertProduct (Product name price)

products :: IO [Product]
products = do
  conn <- connect defaultConnectInfo { 
    connectPassword = "",
    connectDatabase = "pet_store",
    connectUser = "jleakakos"
    }
  query_ conn "select name, price from products" :: IO [Product]
  
