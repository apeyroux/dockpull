{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

module Main where

import Shelly
import System.Environment
import Control.Exception.Base

import qualified Data.Text as T
import qualified Data.Text.IO as TIO

default (T.Text)

main :: IO ()
main = do
  [images, hub] <- getArgs
  f <- TIO.readFile images
  shellyFailDir $ silently $ 
    mapM_ (\x -> catch_sh (do
                              echo $ "[1/3] pull image " <> x <> "..."
                              run_ "docker" ["pull", x]
                              echo $ "[2/3] tag image  " <> T.pack hub <> "/" <> x <> "..."
                              run_ "docker" ["tag", x, T.pack hub <> "/" <> x]
                              echo $ "[3/3] save image " <> T.pack hub <> "/" <> x <> "..."
                              run_ "docker" ["save", T.pack hub <> "/" <> x, "-o", "images/" <> x <> ".docker"]
                          ) (\e -> echo ("Oops: " <> (T.pack $ show (e :: IOException))))
          ) $ T.splitOn "\n" f
