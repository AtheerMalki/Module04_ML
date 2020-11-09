{
  "nbformat": 4,
  "nbformat_minor": 0,
  "metadata": {
    "colab": {
      "name": "Untitled1.ipynb",
      "provenance": [],
      "collapsed_sections": [],
      "authorship_tag": "ABX9TyPBLgxS2m5tq6UTEYzWge/6",
      "include_colab_link": true
    },
    "kernelspec": {
      "name": "ir",
      "display_name": "R"
    }
  },
  "cells": [
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "view-in-github",
        "colab_type": "text"
      },
      "source": [
        "<a href=\"https://colab.research.google.com/github/AtheerMalki/Module04_ML/blob/main/cost_function_assignment.r\" target=\"_parent\"><img src=\"https://colab.research.google.com/assets/colab-badge.svg\" alt=\"Open In Colab\"/></a>"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "pWm3FABi_ZFF"
      },
      "source": [
        "# Heuristic Models (Cost Function Extension)\n",
        "############################################################\n",
        "# Look at the seattle weather in the data folder.\n",
        "# Come up with a heuristic model to predict if\n",
        "# it will rain today. Keep in mind this is a time series,\n",
        "# which means that you only know what happened \n",
        "# historically (before a given date). One example of a\n",
        "# heuristic model is: it will rain tomorrow if it rained\n",
        "# more than 1 inch (>1.0 PRCP) today. Describe your heuristic\n",
        "# model here\n",
        "\n",
        "#############################################################\n",
        "\n",
        "##################### Your model Here #######################\n",
        "\n",
        "#############################################################\n",
        "\n",
        "# Examples:\n",
        "# if it rained yesterday it will rain today\n",
        "# if it rained yesterday or the day before, it will rain today\n",
        "\n",
        "# Here is an example of how to build and populate \n",
        "# a heuristic model\n",
        "library(tidyverse)\n",
        "df <- read.csv(\"https://raw.githubusercontent.com/daniel-dc-cd/data_science/master/module_4_ML/data/seattle_weather_1948-2017.csv\")\n",
        "\n",
        "numrow = 25549\n",
        "\n",
        "heuristic_df <- data.frame(\"Yesterday\" = 0,\n",
        "                           \"Today\" = 0,\n",
        "                           \"Tomorrow\" = 0,\n",
        "                           \"Guess\" = FALSE,\n",
        "                           \"Rain Tomorrow\" = FALSE,\n",
        "                           \"Correct\" = FALSE,\n",
        "                           \"True Positive\" = FALSE,\n",
        "                           \"False Positive\" = FALSE,\n",
        "                           \"True Negative\" = FALSE,\n",
        "                           \"False Negative\" = FALSE)\n"
      ],
      "execution_count": 2,
      "outputs": []
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "lQfDI3r6E5UY",
        "outputId": "112ead43-0066-4a18-be0e-3b9ded096ac1",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 221
        }
      },
      "source": [
        "dim(df)\n",
        "head(df)"
      ],
      "execution_count": 29,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "[1] 25551     5"
            ],
            "text/latex": "\\begin{enumerate*}\n\\item 25551\n\\item 5\n\\end{enumerate*}\n",
            "text/markdown": "1. 25551\n2. 5\n\n\n",
            "text/html": [
              "<style>\n",
              ".list-inline {list-style: none; margin:0; padding: 0}\n",
              ".list-inline>li {display: inline-block}\n",
              ".list-inline>li:not(:last-child)::after {content: \"\\00b7\"; padding: 0 .5ex}\n",
              "</style>\n",
              "<ol class=list-inline><li>25551</li><li>5</li></ol>\n"
            ]
          },
          "metadata": {
            "tags": []
          }
        },
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "  DATE       PRCP TMAX TMIN RAIN\n",
              "1 1948-01-01 0.47 51   42   TRUE\n",
              "2 1948-01-02 0.59 45   36   TRUE\n",
              "3 1948-01-03 0.42 45   35   TRUE\n",
              "4 1948-01-04 0.31 45   34   TRUE\n",
              "5 1948-01-05 0.17 45   32   TRUE\n",
              "6 1948-01-06 0.44 48   39   TRUE"
            ],
            "text/latex": "A data.frame: 6 × 5\n\\begin{tabular}{r|lllll}\n  & DATE & PRCP & TMAX & TMIN & RAIN\\\\\n  & <chr> & <dbl> & <int> & <int> & <lgl>\\\\\n\\hline\n\t1 & 1948-01-01 & 0.47 & 51 & 42 & TRUE\\\\\n\t2 & 1948-01-02 & 0.59 & 45 & 36 & TRUE\\\\\n\t3 & 1948-01-03 & 0.42 & 45 & 35 & TRUE\\\\\n\t4 & 1948-01-04 & 0.31 & 45 & 34 & TRUE\\\\\n\t5 & 1948-01-05 & 0.17 & 45 & 32 & TRUE\\\\\n\t6 & 1948-01-06 & 0.44 & 48 & 39 & TRUE\\\\\n\\end{tabular}\n",
            "text/markdown": "\nA data.frame: 6 × 5\n\n| <!--/--> | DATE &lt;chr&gt; | PRCP &lt;dbl&gt; | TMAX &lt;int&gt; | TMIN &lt;int&gt; | RAIN &lt;lgl&gt; |\n|---|---|---|---|---|---|\n| 1 | 1948-01-01 | 0.47 | 51 | 42 | TRUE |\n| 2 | 1948-01-02 | 0.59 | 45 | 36 | TRUE |\n| 3 | 1948-01-03 | 0.42 | 45 | 35 | TRUE |\n| 4 | 1948-01-04 | 0.31 | 45 | 34 | TRUE |\n| 5 | 1948-01-05 | 0.17 | 45 | 32 | TRUE |\n| 6 | 1948-01-06 | 0.44 | 48 | 39 | TRUE |\n\n",
            "text/html": [
              "<table>\n",
              "<caption>A data.frame: 6 × 5</caption>\n",
              "<thead>\n",
              "\t<tr><th></th><th scope=col>DATE</th><th scope=col>PRCP</th><th scope=col>TMAX</th><th scope=col>TMIN</th><th scope=col>RAIN</th></tr>\n",
              "\t<tr><th></th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;lgl&gt;</th></tr>\n",
              "</thead>\n",
              "<tbody>\n",
              "\t<tr><th scope=row>1</th><td>1948-01-01</td><td>0.47</td><td>51</td><td>42</td><td>TRUE</td></tr>\n",
              "\t<tr><th scope=row>2</th><td>1948-01-02</td><td>0.59</td><td>45</td><td>36</td><td>TRUE</td></tr>\n",
              "\t<tr><th scope=row>3</th><td>1948-01-03</td><td>0.42</td><td>45</td><td>35</td><td>TRUE</td></tr>\n",
              "\t<tr><th scope=row>4</th><td>1948-01-04</td><td>0.31</td><td>45</td><td>34</td><td>TRUE</td></tr>\n",
              "\t<tr><th scope=row>5</th><td>1948-01-05</td><td>0.17</td><td>45</td><td>32</td><td>TRUE</td></tr>\n",
              "\t<tr><th scope=row>6</th><td>1948-01-06</td><td>0.44</td><td>48</td><td>39</td><td>TRUE</td></tr>\n",
              "</tbody>\n",
              "</table>\n"
            ]
          },
          "metadata": {
            "tags": []
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "Y0SnHFQB_wvQ"
      },
      "source": [
        "# Now let's populate our heuristic model guessess\n",
        "df$PRCP = ifelse(is.na(df$PRCP),\n",
        "                 ave(df$PRCP, FUN = function(x) mean(x, na.rm = TRUE)),\n",
        "                 df$PRCP)\n",
        "\n",
        "for (z in 1:numrow){\n",
        "  i = z + 2\n",
        "  yesterday = df[i-2,2]\n",
        "  today = df[i-1,2]\n",
        "  tomorrow = df[i,2]\n",
        "  if (tomorrow == 0){\n",
        "    rain_tomorrow = FALSE\n",
        "  }else{\n",
        "    rain_tomorrow = TRUE\n",
        "  }\n",
        "  heuristic_df[z,1] = yesterday\n",
        "  heuristic_df[z,2] = today\n",
        "  heuristic_df[z,3] = tomorrow\n",
        "  heuristic_df[z,4] = FALSE # Label all guesses as false\n",
        "  heuristic_df[z,5] = rain_tomorrow\n",
        "  heuristic_df[z,7] = FALSE\n",
        "  heuristic_df[z,8] = FALSE\n",
        "  heuristic_df[z,9] = FALSE\n",
        "  heuristic_df[z,10] = FALSE\n",
        "  \n",
        "  if ((today > 0) & (yesterday > 0)){\n",
        "    heuristic_df[z,4] = TRUE\n",
        "  }\n",
        "  if (heuristic_df[z,4] == heuristic_df[z,5]){\n",
        "    heuristic_df[z,6] = TRUE\n",
        "    if (heuristic_df[z,4] == TRUE){\n",
        "      heuristic_df[z,7] = TRUE #true positive\n",
        "    }else{\n",
        "      heuristic_df[z,9] = TRUE #True negative\n",
        "    }\n",
        "  }else{\n",
        "    heuristic_df[z,6] = FALSE\n",
        "    if (heuristic_df[z,4] == TRUE){\n",
        "      heuristic_df[z,7] = TRUE #false positive\n",
        "    }else{\n",
        "      heuristic_df[z,9] = TRUE #false negative\n",
        "    }\n",
        "  }\n",
        "}"
      ],
      "execution_count": 77,
      "outputs": []
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "HJmUcov-A1O1",
        "outputId": "79605a8e-324f-484e-e965-f5260082a2c9",
        "colab": {
          "base_uri": "https://localhost:8080/"
        }
      },
      "source": [
        "print(heuristic_df, max=100)"
      ],
      "execution_count": 78,
      "outputs": [
        {
          "output_type": "stream",
          "text": [
            "   Yesterday Today Tomorrow Guess Rain.Tomorrow Correct True.Positive\n",
            "1       0.47  0.59     0.42  TRUE          TRUE    TRUE          TRUE\n",
            "2       0.59  0.42     0.31  TRUE          TRUE    TRUE          TRUE\n",
            "3       0.42  0.31     0.17  TRUE          TRUE    TRUE          TRUE\n",
            "4       0.31  0.17     0.44  TRUE          TRUE    TRUE          TRUE\n",
            "5       0.17  0.44     0.41  TRUE          TRUE    TRUE          TRUE\n",
            "6       0.44  0.41     0.04  TRUE          TRUE    TRUE          TRUE\n",
            "7       0.41  0.04     0.12  TRUE          TRUE    TRUE          TRUE\n",
            "8       0.04  0.12     0.74  TRUE          TRUE    TRUE          TRUE\n",
            "9       0.12  0.74     0.01  TRUE          TRUE    TRUE          TRUE\n",
            "10      0.74  0.01     0.00  TRUE         FALSE   FALSE          TRUE\n",
            "   False.Positive True.Negative False.Negative\n",
            "1           FALSE         FALSE          FALSE\n",
            "2           FALSE         FALSE          FALSE\n",
            "3           FALSE         FALSE          FALSE\n",
            "4           FALSE         FALSE          FALSE\n",
            "5           FALSE         FALSE          FALSE\n",
            "6           FALSE         FALSE          FALSE\n",
            "7           FALSE         FALSE          FALSE\n",
            "8           FALSE         FALSE          FALSE\n",
            "9           FALSE         FALSE          FALSE\n",
            "10          FALSE         FALSE          FALSE\n",
            " [ reached 'max' / getOption(\"max.print\") -- omitted 25539 rows ]\n"
          ],
          "name": "stdout"
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "NZ2fFrQtBCBu"
      },
      "source": [
        "# Split data into training and testing\n",
        "## enter split function here to make h_train and h_test subsets of the data\n",
        "sample <- sample.int(n = nrow(heuristic_df), size = floor(.70*nrow(heuristic_df)), replace = F)  # for a 70:30 split\n",
        "h_train <- heuristic_df[sample, ]\n",
        "h_test  <- heuristic_df[-sample, ]"
      ],
      "execution_count": 79,
      "outputs": []
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "tDe0qJiVJozP",
        "outputId": "4bac830b-69a0-4677-9227-3c86596b83e7",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 221
        }
      },
      "source": [
        "dim(h_train)\n",
        "head(h_train)"
      ],
      "execution_count": 80,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "[1] 17884    10"
            ],
            "text/latex": "\\begin{enumerate*}\n\\item 17884\n\\item 10\n\\end{enumerate*}\n",
            "text/markdown": "1. 17884\n2. 10\n\n\n",
            "text/html": [
              "<style>\n",
              ".list-inline {list-style: none; margin:0; padding: 0}\n",
              ".list-inline>li {display: inline-block}\n",
              ".list-inline>li:not(:last-child)::after {content: \"\\00b7\"; padding: 0 .5ex}\n",
              "</style>\n",
              "<ol class=list-inline><li>17884</li><li>10</li></ol>\n"
            ]
          },
          "metadata": {
            "tags": []
          }
        },
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "      Yesterday Today Tomorrow Guess Rain.Tomorrow Correct True.Positive\n",
              "17602 0.41      0.22  0.05      TRUE  TRUE          TRUE    TRUE        \n",
              "3598  0.00      0.00  0.00     FALSE FALSE          TRUE   FALSE        \n",
              "16029 0.82      0.19  0.00      TRUE FALSE         FALSE    TRUE        \n",
              "21712 0.00      0.00  0.01     FALSE  TRUE         FALSE   FALSE        \n",
              "73    0.02      0.00  0.00     FALSE FALSE          TRUE   FALSE        \n",
              "13781 0.00      0.00  0.00     FALSE FALSE          TRUE   FALSE        \n",
              "      False.Positive True.Negative False.Negative\n",
              "17602 FALSE          FALSE         FALSE         \n",
              "3598  FALSE           TRUE         FALSE         \n",
              "16029 FALSE          FALSE         FALSE         \n",
              "21712 FALSE           TRUE         FALSE         \n",
              "73    FALSE           TRUE         FALSE         \n",
              "13781 FALSE           TRUE         FALSE         "
            ],
            "text/latex": "A data.frame: 6 × 10\n\\begin{tabular}{r|llllllllll}\n  & Yesterday & Today & Tomorrow & Guess & Rain.Tomorrow & Correct & True.Positive & False.Positive & True.Negative & False.Negative\\\\\n  & <dbl> & <dbl> & <dbl> & <lgl> & <lgl> & <lgl> & <lgl> & <lgl> & <lgl> & <lgl>\\\\\n\\hline\n\t17602 & 0.41 & 0.22 & 0.05 &  TRUE &  TRUE &  TRUE &  TRUE & FALSE & FALSE & FALSE\\\\\n\t3598 & 0.00 & 0.00 & 0.00 & FALSE & FALSE &  TRUE & FALSE & FALSE &  TRUE & FALSE\\\\\n\t16029 & 0.82 & 0.19 & 0.00 &  TRUE & FALSE & FALSE &  TRUE & FALSE & FALSE & FALSE\\\\\n\t21712 & 0.00 & 0.00 & 0.01 & FALSE &  TRUE & FALSE & FALSE & FALSE &  TRUE & FALSE\\\\\n\t73 & 0.02 & 0.00 & 0.00 & FALSE & FALSE &  TRUE & FALSE & FALSE &  TRUE & FALSE\\\\\n\t13781 & 0.00 & 0.00 & 0.00 & FALSE & FALSE &  TRUE & FALSE & FALSE &  TRUE & FALSE\\\\\n\\end{tabular}\n",
            "text/markdown": "\nA data.frame: 6 × 10\n\n| <!--/--> | Yesterday &lt;dbl&gt; | Today &lt;dbl&gt; | Tomorrow &lt;dbl&gt; | Guess &lt;lgl&gt; | Rain.Tomorrow &lt;lgl&gt; | Correct &lt;lgl&gt; | True.Positive &lt;lgl&gt; | False.Positive &lt;lgl&gt; | True.Negative &lt;lgl&gt; | False.Negative &lt;lgl&gt; |\n|---|---|---|---|---|---|---|---|---|---|---|\n| 17602 | 0.41 | 0.22 | 0.05 |  TRUE |  TRUE |  TRUE |  TRUE | FALSE | FALSE | FALSE |\n| 3598 | 0.00 | 0.00 | 0.00 | FALSE | FALSE |  TRUE | FALSE | FALSE |  TRUE | FALSE |\n| 16029 | 0.82 | 0.19 | 0.00 |  TRUE | FALSE | FALSE |  TRUE | FALSE | FALSE | FALSE |\n| 21712 | 0.00 | 0.00 | 0.01 | FALSE |  TRUE | FALSE | FALSE | FALSE |  TRUE | FALSE |\n| 73 | 0.02 | 0.00 | 0.00 | FALSE | FALSE |  TRUE | FALSE | FALSE |  TRUE | FALSE |\n| 13781 | 0.00 | 0.00 | 0.00 | FALSE | FALSE |  TRUE | FALSE | FALSE |  TRUE | FALSE |\n\n",
            "text/html": [
              "<table>\n",
              "<caption>A data.frame: 6 × 10</caption>\n",
              "<thead>\n",
              "\t<tr><th></th><th scope=col>Yesterday</th><th scope=col>Today</th><th scope=col>Tomorrow</th><th scope=col>Guess</th><th scope=col>Rain.Tomorrow</th><th scope=col>Correct</th><th scope=col>True.Positive</th><th scope=col>False.Positive</th><th scope=col>True.Negative</th><th scope=col>False.Negative</th></tr>\n",
              "\t<tr><th></th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;lgl&gt;</th><th scope=col>&lt;lgl&gt;</th><th scope=col>&lt;lgl&gt;</th><th scope=col>&lt;lgl&gt;</th><th scope=col>&lt;lgl&gt;</th><th scope=col>&lt;lgl&gt;</th><th scope=col>&lt;lgl&gt;</th></tr>\n",
              "</thead>\n",
              "<tbody>\n",
              "\t<tr><th scope=row>17602</th><td>0.41</td><td>0.22</td><td>0.05</td><td> TRUE</td><td> TRUE</td><td> TRUE</td><td> TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td></tr>\n",
              "\t<tr><th scope=row>3598</th><td>0.00</td><td>0.00</td><td>0.00</td><td>FALSE</td><td>FALSE</td><td> TRUE</td><td>FALSE</td><td>FALSE</td><td> TRUE</td><td>FALSE</td></tr>\n",
              "\t<tr><th scope=row>16029</th><td>0.82</td><td>0.19</td><td>0.00</td><td> TRUE</td><td>FALSE</td><td>FALSE</td><td> TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td></tr>\n",
              "\t<tr><th scope=row>21712</th><td>0.00</td><td>0.00</td><td>0.01</td><td>FALSE</td><td> TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td> TRUE</td><td>FALSE</td></tr>\n",
              "\t<tr><th scope=row>73</th><td>0.02</td><td>0.00</td><td>0.00</td><td>FALSE</td><td>FALSE</td><td> TRUE</td><td>FALSE</td><td>FALSE</td><td> TRUE</td><td>FALSE</td></tr>\n",
              "\t<tr><th scope=row>13781</th><td>0.00</td><td>0.00</td><td>0.00</td><td>FALSE</td><td>FALSE</td><td> TRUE</td><td>FALSE</td><td>FALSE</td><td> TRUE</td><td>FALSE</td></tr>\n",
              "</tbody>\n",
              "</table>\n"
            ]
          },
          "metadata": {
            "tags": []
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "a17rHAFgK59M",
        "outputId": "c9bfb4bd-ea4a-45f4-dca4-1405ff300142",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 221
        }
      },
      "source": [
        "dim(h_test)\n",
        "head(h_test)"
      ],
      "execution_count": 81,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "[1] 7665   10"
            ],
            "text/latex": "\\begin{enumerate*}\n\\item 7665\n\\item 10\n\\end{enumerate*}\n",
            "text/markdown": "1. 7665\n2. 10\n\n\n",
            "text/html": [
              "<style>\n",
              ".list-inline {list-style: none; margin:0; padding: 0}\n",
              ".list-inline>li {display: inline-block}\n",
              ".list-inline>li:not(:last-child)::after {content: \"\\00b7\"; padding: 0 .5ex}\n",
              "</style>\n",
              "<ol class=list-inline><li>7665</li><li>10</li></ol>\n"
            ]
          },
          "metadata": {
            "tags": []
          }
        },
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "   Yesterday Today Tomorrow Guess Rain.Tomorrow Correct True.Positive\n",
              "4  0.31      0.17  0.44      TRUE  TRUE          TRUE    TRUE        \n",
              "10 0.74      0.01  0.00      TRUE FALSE         FALSE    TRUE        \n",
              "12 0.00      0.00  0.00     FALSE FALSE          TRUE   FALSE        \n",
              "14 0.00      0.00  0.00     FALSE FALSE          TRUE   FALSE        \n",
              "20 0.00      0.00  0.21     FALSE  TRUE         FALSE   FALSE        \n",
              "23 0.00      0.10  0.00     FALSE FALSE          TRUE   FALSE        \n",
              "   False.Positive True.Negative False.Negative\n",
              "4  FALSE          FALSE         FALSE         \n",
              "10 FALSE          FALSE         FALSE         \n",
              "12 FALSE           TRUE         FALSE         \n",
              "14 FALSE           TRUE         FALSE         \n",
              "20 FALSE           TRUE         FALSE         \n",
              "23 FALSE           TRUE         FALSE         "
            ],
            "text/latex": "A data.frame: 6 × 10\n\\begin{tabular}{r|llllllllll}\n  & Yesterday & Today & Tomorrow & Guess & Rain.Tomorrow & Correct & True.Positive & False.Positive & True.Negative & False.Negative\\\\\n  & <dbl> & <dbl> & <dbl> & <lgl> & <lgl> & <lgl> & <lgl> & <lgl> & <lgl> & <lgl>\\\\\n\\hline\n\t4 & 0.31 & 0.17 & 0.44 &  TRUE &  TRUE &  TRUE &  TRUE & FALSE & FALSE & FALSE\\\\\n\t10 & 0.74 & 0.01 & 0.00 &  TRUE & FALSE & FALSE &  TRUE & FALSE & FALSE & FALSE\\\\\n\t12 & 0.00 & 0.00 & 0.00 & FALSE & FALSE &  TRUE & FALSE & FALSE &  TRUE & FALSE\\\\\n\t14 & 0.00 & 0.00 & 0.00 & FALSE & FALSE &  TRUE & FALSE & FALSE &  TRUE & FALSE\\\\\n\t20 & 0.00 & 0.00 & 0.21 & FALSE &  TRUE & FALSE & FALSE & FALSE &  TRUE & FALSE\\\\\n\t23 & 0.00 & 0.10 & 0.00 & FALSE & FALSE &  TRUE & FALSE & FALSE &  TRUE & FALSE\\\\\n\\end{tabular}\n",
            "text/markdown": "\nA data.frame: 6 × 10\n\n| <!--/--> | Yesterday &lt;dbl&gt; | Today &lt;dbl&gt; | Tomorrow &lt;dbl&gt; | Guess &lt;lgl&gt; | Rain.Tomorrow &lt;lgl&gt; | Correct &lt;lgl&gt; | True.Positive &lt;lgl&gt; | False.Positive &lt;lgl&gt; | True.Negative &lt;lgl&gt; | False.Negative &lt;lgl&gt; |\n|---|---|---|---|---|---|---|---|---|---|---|\n| 4 | 0.31 | 0.17 | 0.44 |  TRUE |  TRUE |  TRUE |  TRUE | FALSE | FALSE | FALSE |\n| 10 | 0.74 | 0.01 | 0.00 |  TRUE | FALSE | FALSE |  TRUE | FALSE | FALSE | FALSE |\n| 12 | 0.00 | 0.00 | 0.00 | FALSE | FALSE |  TRUE | FALSE | FALSE |  TRUE | FALSE |\n| 14 | 0.00 | 0.00 | 0.00 | FALSE | FALSE |  TRUE | FALSE | FALSE |  TRUE | FALSE |\n| 20 | 0.00 | 0.00 | 0.21 | FALSE |  TRUE | FALSE | FALSE | FALSE |  TRUE | FALSE |\n| 23 | 0.00 | 0.10 | 0.00 | FALSE | FALSE |  TRUE | FALSE | FALSE |  TRUE | FALSE |\n\n",
            "text/html": [
              "<table>\n",
              "<caption>A data.frame: 6 × 10</caption>\n",
              "<thead>\n",
              "\t<tr><th></th><th scope=col>Yesterday</th><th scope=col>Today</th><th scope=col>Tomorrow</th><th scope=col>Guess</th><th scope=col>Rain.Tomorrow</th><th scope=col>Correct</th><th scope=col>True.Positive</th><th scope=col>False.Positive</th><th scope=col>True.Negative</th><th scope=col>False.Negative</th></tr>\n",
              "\t<tr><th></th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;lgl&gt;</th><th scope=col>&lt;lgl&gt;</th><th scope=col>&lt;lgl&gt;</th><th scope=col>&lt;lgl&gt;</th><th scope=col>&lt;lgl&gt;</th><th scope=col>&lt;lgl&gt;</th><th scope=col>&lt;lgl&gt;</th></tr>\n",
              "</thead>\n",
              "<tbody>\n",
              "\t<tr><th scope=row>4</th><td>0.31</td><td>0.17</td><td>0.44</td><td> TRUE</td><td> TRUE</td><td> TRUE</td><td> TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td></tr>\n",
              "\t<tr><th scope=row>10</th><td>0.74</td><td>0.01</td><td>0.00</td><td> TRUE</td><td>FALSE</td><td>FALSE</td><td> TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td></tr>\n",
              "\t<tr><th scope=row>12</th><td>0.00</td><td>0.00</td><td>0.00</td><td>FALSE</td><td>FALSE</td><td> TRUE</td><td>FALSE</td><td>FALSE</td><td> TRUE</td><td>FALSE</td></tr>\n",
              "\t<tr><th scope=row>14</th><td>0.00</td><td>0.00</td><td>0.00</td><td>FALSE</td><td>FALSE</td><td> TRUE</td><td>FALSE</td><td>FALSE</td><td> TRUE</td><td>FALSE</td></tr>\n",
              "\t<tr><th scope=row>20</th><td>0.00</td><td>0.00</td><td>0.21</td><td>FALSE</td><td> TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td> TRUE</td><td>FALSE</td></tr>\n",
              "\t<tr><th scope=row>23</th><td>0.00</td><td>0.10</td><td>0.00</td><td>FALSE</td><td>FALSE</td><td> TRUE</td><td>FALSE</td><td>FALSE</td><td> TRUE</td><td>FALSE</td></tr>\n",
              "</tbody>\n",
              "</table>\n"
            ]
          },
          "metadata": {
            "tags": []
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "2yeP0a3vHMUE",
        "outputId": "920fa72d-2a50-4229-b764-8b9031bb66f0",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 34
        }
      },
      "source": [
        "# Calculate the accuracy of your predictions\n",
        "# we used this simple approach in the first part to see what percent of the time we where correct \n",
        "# calculated as (true positive + true negative)/ number of guesses\n",
        "\n",
        "acc = as.numeric(( sum(heuristic_df[,6]) + sum(heuristic_df[,8]) ) / count(heuristic_df) * 100)\n",
        "acc"
      ],
      "execution_count": 95,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "[1] 67.15723"
            ],
            "text/latex": "67.1572272887393",
            "text/markdown": "67.1572272887393",
            "text/html": [
              "67.1572272887393"
            ]
          },
          "metadata": {
            "tags": []
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "Fv-s9ElpHeFR",
        "outputId": "d3cf0cfc-0f26-4ea7-e282-7d9f8a46b0cc",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 34
        }
      },
      "source": [
        "# Calculate the precision of your prediction\n",
        "# precision is the percent of your postive prediction which are correct\n",
        "# more specifically it is calculated (num true positive)/(num tru positive + num false positive)\n",
        "\n",
        "prec = as.numeric(sum(heuristic_df[,6]) / ( sum(heuristic_df[,6]) + sum(heuristic_df[,7]) ) * 100)\n",
        "prec"
      ],
      "execution_count": 96,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "[1] 70.40624"
            ],
            "text/latex": "70.4062371768568",
            "text/markdown": "70.4062371768568",
            "text/html": [
              "70.4062371768568"
            ]
          },
          "metadata": {
            "tags": []
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "YmOyKBIXHalj",
        "outputId": "cdd4187c-f3fb-4c02-c255-16859dd5965b",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 34
        }
      },
      "source": [
        "# Calculate the recall of your predictions\n",
        "# recall the percent of the time you are correct when you predict positive\n",
        "# more specifically it is calculated (num true positive)/(num tru positive + num false negative)\n",
        "\n",
        "rec = sum(heuristic_df[,6]) / ( sum(heuristic_df[,6]) + sum(heuristic_df[,9])) * 100\n",
        "rec"
      ],
      "execution_count": 101,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "[1] 48.3392"
            ],
            "text/latex": "48.3392027046063",
            "text/markdown": "48.3392027046063",
            "text/html": [
              "48.3392027046063"
            ]
          },
          "metadata": {
            "tags": []
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "lEe5QoqzHjOK"
      },
      "source": [
        "# The sum of squared error (SSE) of your predictions\n"
      ],
      "execution_count": 102,
      "outputs": []
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "Uflbcy3xiHrt"
      },
      "source": [
        ""
      ],
      "execution_count": null,
      "outputs": []
    }
  ]
}