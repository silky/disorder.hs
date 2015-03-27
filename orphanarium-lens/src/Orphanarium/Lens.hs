{-# LANGUAGE RankNTypes #-}
module Orphanarium.Lens (
    -- * Prism Laws
        prismSymmetry
    ,   prismConverseSymmetry
    ,   prismLaws
    -- * Traversal Laws
    ,   traversalPure
    ) where

import Control.Applicative ( pure )
import Control.Lens ( Traversal', Prism', (^.) , (^?), (.~), mapped, re )
import Test.QuickCheck ( Property, (===), conjoin )

-- Prism Laws

prismSymmetry :: (Show a, Eq a) => Prism' s a -> a -> Property
prismSymmetry l y = (y ^. re l) ^? l === pure y

prismConverseSymmetry :: (Show s, Eq s) => Prism' s a -> s -> Property
prismConverseSymmetry l x = fmap (^. re l) (x ^? l) === (mapped .~ x) (x ^? l)

-- |
-- Prisms must satisfy the Symmetry and Converse Symmetry laws as well as the Traversal Laws.
--
prismLaws :: (Show a, Eq a, Show s, Eq s) => Prism' s a -> s -> a -> Property
prismLaws p x y = conjoin [prismSymmetry p y, prismConverseSymmetry p x, traversalPure p x]

-- Traversal Laws

-- The `fmap (t f) . t g ≡ getCompose . t (Compose . fmap f . g)` law isnt here yet,
-- but I *think* parametricity (combined with `traversalPure`) will cover it (?).

traversalPure :: (Show s, Eq s) => Traversal' s a -> s -> Property
traversalPure t x = t Just x === Just x