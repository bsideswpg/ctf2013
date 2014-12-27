start_time = os.time()

challenges = {
  { name = "yo",           flag = "b4ck_dat_asm_up"                  },
  { name = "oldschool",    flag = "I_USE_THEM_AS_BOOKM4RKZ"          },
  { name = "pitch",        flag = "now_wasnt_that_easy"              },
  { name = "tootsie",      flag = "3nj0i_ur_RSI"                     },
  { name = "tapdat",       flag = "A_PLUS_WOULD_SHIFT_AGAIN"         },
  { name = "dangle",       flag = "the_genetic_opera"                },
  { name = "factoryfresh", flag = "little_blakc_bawks"               },
  { name = "cryptic",      flag = "Braille_Brissik_in_the_place"     },
  { name = "rascal",       flag = "high_func7ioning_hack3rs"         },
  { name = "demo",         flag = "you_must_run_it"                  },
  { name = "asshat",       flag = "14t3f0r4d4t3"                     },
  { name = "bootliquor",   flag = "L3ts_G3t_W3t"                     },
  { name = "cosmo",        flag = "mai_v0ise_is_mai_paszp0rt"        },
  { name = "scumbag",      flag = "DONT-HAET-ZE-AUTHR-HATE-MAI--CTF" },
}

-- The regex used to pull out the team name and the flag from the Nginx logs
LOG_REGEX = '"GET /flags/([-_a-zA-Z0-9]+)/([-_a-zA-Z0-9]+)'

function keys(t)
  local keys = {}

  for key, _ in pairs(t) do
    table.insert(keys, key)
  end

  return keys
end

-- Data structure for two purposes:
-- - Determining if a flag is 'correct'
-- - Mapping a submitted flag to the challenge's name
flag_to_name = {}
for _, challenge in ipairs(challenges) do
  flag_to_name[challenge.flag] = challenge.name
end


-- This structure is a hash table mapping usernames to hash tables of
-- completed challenges
completions = {}

-- This is used to record who reached a rank first, and is used for
-- ordering people who are tied for a score
score_to_teams = {}

-- Read all log lines, keeping track of who solved what challenges,
-- and the order which people reached their scores
lines = 0
for line in io.lines() do
  lines = lines + 1
  local team_name, flag = string.match(line, LOG_REGEX)

  if team_name ~= nil and team_name ~= "team_name_here" and flag ~= nil and #team_name < 33 and #flag < 33 then
    if flag_to_name[flag] then
      completions[team_name] = completions[team_name] or {}
      local challenge_name = flag_to_name[flag]

      -- If this is the first time someone has gotten this flag,
      -- record their rank within that score
      -- People who arrive at a score first are ranked above those
      -- that arrive at a score second, and so on
      if not completions[team_name][challenge_name] then
        -- Mark the flag as captured
        completions[team_name][challenge_name] = true

        -- Append the team to the list of people that have reached
        -- that score
        local score = #keys(completions[team_name])
        score_to_teams[score] = score_to_teams[score] or {}
        table.insert(score_to_teams[score], team_name)
      end
    end
  end
end

-- Produce a Markdown table row
-- Relies on the global challenges and completions tables
function render_markdown_row(team_name, place, score)
  row = "| " .. place .. " | " .. score .. " | " .. team_name .. " |"

  for _, challenge in ipairs(challenges) do
    if completions[team_name][challenge.name] then
      row = row .. ' <span style="color:green">&#10004;</span> |'
    else
      row = row .. ' |'
    end
  end

  row = row .. '\n'
  return row
end


-- Begin HTML/Markdown output

-- Page header
io.write([[
<!--# set var="title" value="BSidesWpgCTF" -->
<link rel="stylesheet" type="text/css" href="/main.css" />
<pre>
    ____ _____ _     __         _       __            __________________
   / __ ) ___/(_)___/ /__  ____| |     / /___  ____ _/ ____/_  __/ ____/
  / __  \__ \/ / __  / _ \/ ___/ | /| / / __ \/ __ `/ /     / / / /_
 / /_/ /__/ / / /_/ /  __(__  )| |/ |/ / /_/ / /_/ / /___  / / / __/
/_____/____/_/\__,_/\___/____/ |__/|__/ .___/\__, /\____/ /_/ /_/
                                     /_/    /____/
</pre>

[home](/)

<span style="color:red"><b>The CTF is closed!</b></span>

Scoreboard
==========


]])

if #score_to_teams == 0 then
  io.write([[
Nobody has scored yet!

</body>
</html>
]])
  os.exit(0)
end

-- If people have scored, continue to building the Markdown table

-- Write the Markdown table header
io.write("| Place | Score | Name |")
for _, challenge in ipairs(challenges) do
  io.write(" " .. challenge.name .. " |")
end
io.write("\n")

for i=1,#challenges+3 do
  io.write("|---")
end
io.write("|\n")


-- Work backwards from highest score to lowest, and for each, work
-- from first team to last team, rendering a row for each.
rendered_teams = {}
place = 0
for score=#score_to_teams,1,-1 do
  for _, team_name in ipairs(score_to_teams[score]) do
    if not rendered_teams[team_name] then
      place = place + 1
      rendered_teams[team_name] = true
      io.write(render_markdown_row(team_name, place, score))
    end
  end
end

io.write([[

</body>
</html>
]])

total_time = os.time() - start_time
io.stderr:write("[ALPHA] Processed " .. lines .. " log lines in ~" .. total_time .. " seconds\n")
