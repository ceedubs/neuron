{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Neuron.Zettelkasten.Meta
  ( Meta (..),
    getMeta,
  )
where

import Data.Aeson
import Relude
import Text.MMark (MMark, projectYaml)

-- | YAML metadata in a zettel markdown file
data Meta = Meta
  { title :: Text,
    tags :: Maybe [Text]
  }
  deriving (Eq, Show, Generic, FromJSON)

getMeta :: MMark -> Maybe Meta
getMeta src = do
  val <- projectYaml src
  case fromJSON val of
    Error e -> error $ "JSON error: " <> toText e
    Success v -> pure v
