# Nurse Family Partnership Impact Evaluation
![NFP](http://dssg.io/img/partners/nfp.jpg)

A statistical analysis of the social impact of Nurse-Family Partnership, a home visitation program.

This is a 2013 [Data Science for Social Good Fellowship](http://dssg.io) project to help the Nurse-Family Partnership evaluate its effectiveness at promoting healthy child developmental outcomes and stable families.

For a quick and gentle overview of the project, check out our [blog post](http://dssg.io/2013/07/31/the-match-game.html).
 
## The problem: evaluating impact without a randomized controlled trial
 
The [Nurse-Family Partnership](http://www.nursefamilypartnership.org) (NFP) is a nation-wide home-visitation program that pairs a nurse with an at-risk first-time mother for the duration of her pregnancy and the first two years of her child's life. 

The Affordable Care Act of 2010 made new money available to home visitation programs such as NFP, but it also required that programs provide evidence of their effectiveness. Although NFP was founded on the basis of several successful randomized controlled trials, these studies were conducted decades ago and in only a handful of states. They need a way to measure their impact across the country using the observational data they have.

However, while NFP's formidable information tracking system affords them a large-scale, systematic perspective on participants' outcomes, they face two principal challenges to performing a country-wide evaluation of their program:

1. NFP's program participants differ from the general population on a range of characteristics, including some, like income or educational attainment, that probably impact the outcomes in question - for example, the wealthier you are, the more likely your kids are to be healthy. As a result, a simple comparison of means between the outcomes of NFP participants and the outcomes of the general population reflects not just NFP's impact but the impact of those factors too. You need to compare apples to apples.

2. To evaluate whether the program is helping participants, then, they would need to compare their outcomes with those of families with similar socioeconomic backgrounds who weren't in the program. But NFP does not track data on child and mother outcomes for families they don't serve.

**[Read more about the problem in our wiki.](https://github.com/dssg/nfp/wiki/Problem)**


## The solution: statistical matching techniques

To assist NFP, we used [statistical matching techniques](http://en.wikipedia.org/wiki/Matching_(statistics\)) to identify women in public national datasets who are similar on all observable characteristics (such as demographics) to the women in NFP's administrative data. We can plausibly estimate NFP's impact as the difference in outcomes between these two groups.

Our project had two goals:

1. To provide a rough evaluation of NFP's impact at a national level. Although this study will not have the same validity as a randomized controlled trial, it represents a significant improvement over the evidence basis that would otherwise be available to current decision processes.

2. To develop a methodology for basic impact evaluation of nonprofit programs where resource limitations and program size make traditional experimental evaluations impractical or impossible.

For a quick introduction to matching, read our [blog post](http://dssg.io/2013/07/19/the-dark-matter-part-two.html).

**[Read more about our methodology in our wiki.](https://github.com/dssg/nfp/wiki/Methodology)**


## The data 

NFP ultimately hopes to assess outcomes across a range of areas, including child development and health, mother's life course, and child welfare/intimate partner violence. For this project, we focused on two specific outcomes: immunization and breastfeeding rates. We created our comparison groups from the [National Immunization Survey](http://www.cdc.gov/nchs/nis.htm) and the [National Survey of Children's Health](http://www.childhealthdata.org/learn/NSCH) respectively. We also did some significant exploration in the [Current Population Survey](http://www.census.gov/cps/) as a potential dataset for assessing mother's life outcomes like employment and educational attainment.

**[Read more about the datasets we used - and those we didn't - in our wiki.](https://github.com/dssg/nfp/wiki/Data)**

## Project layout
- The `data_preparation` directory includes all of the scripts we used to clean and reshape our data.  Ultimately, we needed to develop uniform datasets from both the NFP data and the comparison data files, so that we could combine these datasets for analysis.  The code in this directory demonstrates the details of that process.

- The `data_analysis` directory contains the scripts used for our actual analysis, including data exploration and matching.  This directory also includes a few sample/simulation scripts we developed while we explored the details of our methodology.

- At the beginning of the fellowship, we met local NFP nurses to discuss their experiences. They mentioned that one of their most tedious tasks is calculating the number of home visits they need to make with a new client before she gives birth in order to remain NFP compliant. We used the R package [Shiny](http://www.rstudio.com/shiny/) to create a webpage that takes the woman's weeks of gestation as input and gives the number of visits required as output. For more details, see the `Shiny_server` directory.

**Read more detailed documentation in each directory.**


## Using R

All of our data analysis, impact estimation, and data visualization code is written in [R](http://www.r-project.org/), a free and widely-used statistics programming language. 

We chose R so our work could be widely used by the non-profit and research community. But we recognize that many potential users of this code may not have use R before. A few references and tutorials that we highly recommend:

* [Code School's free, interactive tutorial in R](http://www.codeschool.com/courses/try-r)
* Books tailored to one's programming background, such as [R for SAS and SPSS Users](http://www.amazon.com/SAS-SPSS-Users-Statistics-Computing/dp/1461406846/ref=sr_1_1?s=books&ie=UTF8&qid=1376955179&sr=1-1) by Robert Muenchen or  [R for Stata Users](http://www.amazon.com/R-Stata-Users-Statistics-Computing/dp/1461425964/ref=sr_1_2?s=books&ie=UTF8&qid=1376955179&sr=1-2) by Robert Muenchen and Joseph Hilbe
 * Note that these books have excellent, and freely available, code samples for many common operations in R, with comparisons to the equivalent commands in SAS, SPSS and Stata.
* [R in a Nutshell](http://web.udl.es/Biomath/Bioestadistica/R/Manuals/r_in_a_nutshell.pdf) by Joseph Adler, published by O'Reilly
* A number of freely available "quick reference" sheets such as ones by [Tom Short](http://cran.r-project.org/doc/contrib/Short-refcard.pdf), and staff at the [University of Auckland](https://www.stat.auckland.ac.nz/~stat380/downloads/QuickReference.pdf).
* Researchers interested in using R specifically to work with complex national surveys may be interested in [Anthony D'Amico's usgsd repo](https://github.com/ajdamico/usgsd), which includes sample import and analysis scripts for many popular surveys.

## Team
![NFP team](http://dssg.io/img/people/nfp-team.png)

## Contributing to the Project

Because we worked with NFP's private health information, we can't make much of our data public. However, we are opening our code and documenting our methodology so it may be useful for other projects. 

We would love to hear from other individuals using parts of our code, doing the same kind of work, or interested in getting involved.

**Email us at dssg-nfp@googlegroups.com.**


## License

Copyright (C) 2013 Data Science for Social Good Fellowship at the University of Chicago

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS," WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
