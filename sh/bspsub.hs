import Data.Char (isUpper, toLower)
import Data.List (break, intercalate)

-- name, focusedp, occupiedp
data Workspace = Workspace String Bool Bool
-- shitty "hack" because I need both numbers and strings in the reported json
-- doesn't even deserve the title of hack
data JsonElt = JsonInt Int | JsonStr String

main = do s <- getLine
          putStrLn (report_to_json_list s)
          main
  where
    report_to_json_list s = let workspace_strings = workspace_strings_from_report s
                                workspaces = map workspace_from_string workspace_strings
                            in
                              wrap "[" "]" (intercalate "," (map workspace_to_json workspaces))
          
wrap :: String -> String -> String -> String

wrap start end contents = start ++ contents ++ end
workspace_strings_from_report :: String -> [String]
workspace_strings_from_report re =
  takeWhile good_ws_descriptor (dropWhile bad_ws_descriptor (charsep ':' re))
  where
    good_ws_descriptor ws = elem (ws !! 0) "foFO"
    bad_ws_descriptor = not . good_ws_descriptor

charsep :: Char -> String -> [String]
charsep _ [] = []
charsep delim str = let (firstword,rest) = break (==delim) str
                    in firstword : charsep delim (if null rest then [] else (tail rest))

workspace_from_string :: String -> Workspace
workspace_from_string wsStr =
  Workspace (drop 1 wsStr) (isUpper (wsStr !! 0)) ((toLower (wsStr !! 0)) == 'f')

workspace_to_json :: Workspace -> String
workspace_to_json (Workspace name focusedp occupiedp) =
  render_json [("name", JsonStr name),
               ("focused", JsonInt (bool2num focusedp)),
               ("occupied", JsonInt (bool2num occupiedp))]
  where
    bool2num b = if b then 1 else 0

-- this is a rather NOT general purpose json renderer
render_json :: [(String, JsonElt)] -> String
render_json keyval = wrap "{" "}" (intercalate "," (map show_json_keyval keyval))
  where
    show_json_keyval (key, val) = show key ++ ":" ++ show_json_val val
    show_json_val (JsonStr s) = show s
    show_json_val (JsonInt s) = show s
