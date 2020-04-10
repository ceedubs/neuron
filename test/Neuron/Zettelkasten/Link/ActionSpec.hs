{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Neuron.Zettelkasten.Link.ActionSpec
  ( spec,
  )
where

import Neuron.Zettelkasten.ID (Connection (..), ZettelID (..))
import Neuron.Zettelkasten.Link.Action
import Relude
import Test.Hspec
import Text.URI

spec :: Spec
spec = do
  describe "Link Action conversion" $ do
    forM_ linkActionCases $ \(name, link, action) -> do
      it ("converts " <> name) $ do
        linkActionFromLink (uncurry mkMarkdownLink $ either (id &&& id) id link) `shouldBe` action

linkActionCases :: [(String, Either Text (Text, Text), Maybe LinkAction)]
linkActionCases =
  [ ( "alias link",
      (Left "1234567"),
      Just $ LinkAction_ConnectZettel Folgezettel (ZettelID "1234567")
    ),
    ( "legacy z: link",
      (Right ("1234567", "z:")),
      Just $ LinkAction_ConnectZettel Folgezettel (ZettelID "1234567")
    ),
    ( "legacy z: link, with annotation ignored",
      (Right ("1234567", "z://foo-bar")),
      Just $ LinkAction_ConnectZettel Folgezettel (ZettelID "1234567")
    )
  ]

mkMarkdownLink :: Text -> Text -> MarkdownLink
mkMarkdownLink s l =
  MarkdownLink s $ either (error . toText . displayException) id $ mkURI l