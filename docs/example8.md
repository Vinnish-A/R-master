


# 初探R中的面向对象系统

面向对象是一种高级的编程思想，在构建大型项目时格外有用，面向对象的较为详细的阐述可见[python100天](https://www.bookstack.cn/read/Python-100-Days/Day01-15-08.%E9%9D%A2%E5%90%91%E5%AF%B9%E8%B1%A1%E7%BC%96%E7%A8%8B%E5%9F%BA%E7%A1%80.md)。

面向对象有三个特点：封装、继承和多态。我们可以这样简单理解：

-   封装：把低级数据结构封装成我们自定义的高级数据结构，搭配我们设定的一系列方法，实现标准输入、标准输出
-   继承：一个高级数据结构可以来自一个较为低级的数据结构，继承了低级结构的特点
-   多态：高级数据结构之间彼此互不相同

R中有三种主流面向对象系统（新出的S7系统尚未成熟，还有一些古怪的面向对象系统暂且不表），R6最新，最接近现代编程里的主流面向对象结构，S3成熟简单，但和主流思想偏差较大，S4是S3和R6之间的过渡，虽然很多优秀的包都基于S4构建，但是这个结构本身很不便于开发，存在很多不便，这里仅仅带过。

## S3

S3系统来自R语言的前身S语言，简洁强大，但是非常的不规范。

### 解惑

R中一个现象令纯学者困惑，为什么一个函数可以接收不同的数据结构？比如`print`既可以接收data.frame又可以接收tibble，打印出来的内容却不一样。


```r
example_tbl = as_tibble(iris)

print(iris[1:10, ])
```

```
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1           5.1         3.5          1.4         0.2  setosa
## 2           4.9         3.0          1.4         0.2  setosa
## 3           4.7         3.2          1.3         0.2  setosa
## 4           4.6         3.1          1.5         0.2  setosa
## 5           5.0         3.6          1.4         0.2  setosa
## 6           5.4         3.9          1.7         0.4  setosa
## 7           4.6         3.4          1.4         0.3  setosa
## 8           5.0         3.4          1.5         0.2  setosa
## 9           4.4         2.9          1.4         0.2  setosa
## 10          4.9         3.1          1.5         0.1  setosa
```

```r
print(example_tbl)
```

```
## # A tibble: 150 × 5
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
##           <dbl>       <dbl>        <dbl>       <dbl> <fct>  
##  1          5.1         3.5          1.4         0.2 setosa 
##  2          4.9         3            1.4         0.2 setosa 
##  3          4.7         3.2          1.3         0.2 setosa 
##  4          4.6         3.1          1.5         0.2 setosa 
##  5          5           3.6          1.4         0.2 setosa 
##  6          5.4         3.9          1.7         0.4 setosa 
##  7          4.6         3.4          1.4         0.3 setosa 
##  8          5           3.4          1.5         0.2 setosa 
##  9          4.4         2.9          1.4         0.2 setosa 
## 10          4.9         3.1          1.5         0.1 setosa 
## # ℹ 140 more rows
```

或者一个函数接收不同的数据结构，算出来的内容居然是相同的！~~如果你看过变量遮蔽的内容，一定知道这里的with是什么意思，后面的那个波浪号是R中的公式语法~~


```r
a = with(sleep, t.test(extra[group == 1], extra[group == 2]))
b = t.test(extra ~ group, sleep)
c = list(a, b); names(c) = c("numeric", "formula"); c
```

```
## $numeric
## 
## 	Welch Two Sample t-test
## 
## data:  extra[group == 1] and extra[group == 2]
## t = -1.8608, df = 17.776, p-value = 0.07939
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -3.3654832  0.2054832
## sample estimates:
## mean of x mean of y 
##      0.75      2.33 
## 
## 
## $formula
## 
## 	Welch Two Sample t-test
## 
## data:  extra by group
## t = -1.8608, df = 17.776, p-value = 0.07939
## alternative hypothesis: true difference in means between group 1 and group 2 is not equal to 0
## 95 percent confidence interval:
##  -3.3654832  0.2054832
## sample estimates:
## mean in group 1 mean in group 2 
##            0.75            2.33
```

上两者的原因都在于R的S3结构。S3结构的特点是对每个类别可以使用属于各个类别自己方法，命名特点为`函数名 + .类别`，一个变量可以有多个类别，执行一个变量的S3方法时，会从左到右依次往下找有没有对此类别可以用的方法，如果实在找不到，就会使用default方法，这就是所谓的多重继承。

我们可以使用`class`查看每个变量所属的类别


```r
list(class(iris), class(example_tbl))
```

```
## [[1]]
## [1] "data.frame"
## 
## [[2]]
## [1] "tbl_df"     "tbl"        "data.frame"
```

通过`methods`查看一个函数对应的全部类别的所有方法。对于print，一定有对应的`print.data.frame`，`print.tbl`方法。


```r
methods("print")
```

```
##   [1] print.acf*                                          
##   [2] print.activeConcordance*                            
##   [3] print.AES*                                          
##   [4] print.all_vars*                                     
##   [5] print.anova*                                        
##   [6] print.any_vars*                                     
##   [7] print.aov*                                          
##   [8] print.aovlist*                                      
##   [9] print.ar*                                           
##  [10] print.Arima*                                        
##  [11] print.arima0*                                       
##  [12] print.AsIs                                          
##  [13] print.aspell*                                       
##  [14] print.aspell_inspect_context*                       
##  [15] print.bibentry*                                     
##  [16] print.Bibtex*                                       
##  [17] print.browseVignettes*                              
##  [18] print.bslib_breakpoints*                            
##  [19] print.bslib_fragment*                               
##  [20] print.bslib_page*                                   
##  [21] print.bslib_showcase_layout*                        
##  [22] print.bslib_value_box_theme*                        
##  [23] print.by                                            
##  [24] print.cachem*                                       
##  [25] print.changedFiles*                                 
##  [26] print.check_bogus_return*                           
##  [27] print.check_code_usage_in_package*                  
##  [28] print.check_compiled_code*                          
##  [29] print.check_demo_index*                             
##  [30] print.check_depdef*                                 
##  [31] print.check_details*                                
##  [32] print.check_details_changes*                        
##  [33] print.check_doi_db*                                 
##  [34] print.check_dotInternal*                            
##  [35] print.check_make_vars*                              
##  [36] print.check_nonAPI_calls*                           
##  [37] print.check_package_code_assign_to_globalenv*       
##  [38] print.check_package_code_attach*                    
##  [39] print.check_package_code_data_into_globalenv*       
##  [40] print.check_package_code_startup_functions*         
##  [41] print.check_package_code_syntax*                    
##  [42] print.check_package_code_unload_functions*          
##  [43] print.check_package_compact_datasets*               
##  [44] print.check_package_CRAN_incoming*                  
##  [45] print.check_package_datalist*                       
##  [46] print.check_package_datasets*                       
##  [47] print.check_package_depends*                        
##  [48] print.check_package_description*                    
##  [49] print.check_package_description_encoding*           
##  [50] print.check_package_license*                        
##  [51] print.check_packages_in_dir*                        
##  [52] print.check_packages_used*                          
##  [53] print.check_po_files*                               
##  [54] print.check_pragmas*                                
##  [55] print.check_Rd_line_widths*                         
##  [56] print.check_Rd_metadata*                            
##  [57] print.check_Rd_xrefs*                               
##  [58] print.check_RegSym_calls*                           
##  [59] print.check_S3_methods_needing_delayed_registration*
##  [60] print.check_so_symbols*                             
##  [61] print.check_T_and_F*                                
##  [62] print.check_url_db*                                 
##  [63] print.check_vignette_index*                         
##  [64] print.checkDocFiles*                                
##  [65] print.checkDocStyle*                                
##  [66] print.checkFF*                                      
##  [67] print.checkRd*                                      
##  [68] print.checkRdContents*                              
##  [69] print.checkReplaceFuns*                             
##  [70] print.checkS3methods*                               
##  [71] print.checkTnF*                                     
##  [72] print.checkVignettes*                               
##  [73] print.citation*                                     
##  [74] print.cli_ansi_html_style*                          
##  [75] print.cli_ansi_string*                              
##  [76] print.cli_ansi_style*                               
##  [77] print.cli_boxx*                                     
##  [78] print.cli_diff_chr*                                 
##  [79] print.cli_doc*                                      
##  [80] print.cli_progress_demo*                            
##  [81] print.cli_rule*                                     
##  [82] print.cli_sitrep*                                   
##  [83] print.cli_spark*                                    
##  [84] print.cli_spinner*                                  
##  [85] print.cli_tree*                                     
##  [86] print.codoc*                                        
##  [87] print.codocClasses*                                 
##  [88] print.codocData*                                    
##  [89] print.col_spec*                                     
##  [90] print.collector*                                    
##  [91] print.colorConverter*                               
##  [92] print.compactPDF*                                   
##  [93] print.condition                                     
##  [94] print.connection                                    
##  [95] print.CRAN_package_reverse_dependencies_and_views*  
##  [96] print.css*                                          
##  [97] print.data.frame                                    
##  [98] print.Date                                          
##  [99] print.date_names*                                   
## [100] print.default                                       
## [101] print.dendrogram*                                   
## [102] print.density*                                      
## [103] print.difftime                                      
## [104] print.dist*                                         
## [105] print.Dlist                                         
## [106] print.DLLInfo                                       
## [107] print.DLLInfoList                                   
## [108] print.DLLRegisteredRoutines                         
## [109] print.document_context*                             
## [110] print.document_position*                            
## [111] print.document_range*                               
## [112] print.document_selection*                           
## [113] print.dplyr_join_by*                                
## [114] print.dplyr_sel_vars*                               
## [115] print.dummy_coef*                                   
## [116] print.dummy_coef_list*                              
## [117] print.ecdf*                                         
## [118] print.eigen                                         
## [119] print.element*                                      
## [120] print.factanal*                                     
## [121] print.factor                                        
## [122] print.family*                                       
## [123] print.fileSnapshot*                                 
## [124] print.findLineNumResult*                            
## [125] print.flatGridListing*                              
## [126] print.formula*                                      
## [127] print.fseq*                                         
## [128] print.ftable*                                       
## [129] print.fun_list*                                     
## [130] print.function                                      
## [131] print.getAnywhere*                                  
## [132] print.ggplot*                                       
## [133] print.ggplot2_bins*                                 
## [134] print.ggproto*                                      
## [135] print.ggproto_method*                               
## [136] print.gList*                                        
## [137] print.glm*                                          
## [138] print.glue*                                         
## [139] print.gpar*                                         
## [140] print.GridCoords*                                   
## [141] print.GridGrobCoords*                               
## [142] print.GridGTreeCoords*                              
## [143] print.grob*                                         
## [144] print.gtable*                                       
## [145] print.hashtab*                                      
## [146] print.hcl_palettes*                                 
## [147] print.hclust*                                       
## [148] print.help_files_with_topic*                        
## [149] print.hexmode                                       
## [150] print.hms*                                          
## [151] print.HoltWinters*                                  
## [152] print.hsearch*                                      
## [153] print.hsearch_db*                                   
## [154] print.htest*                                        
## [155] print.html*                                         
## [156] print.html_dependency*                              
## [157] print.htmltools.selector*                           
## [158] print.htmltools.selector.list*                      
## [159] print.infl*                                         
## [160] print.integrate*                                    
## [161] print.isoreg*                                       
## [162] print.json*                                         
## [163] print.key_missing*                                  
## [164] print.kmeans*                                       
## [165] print.knitr_kable*                                  
## [166] print.last_dplyr_warnings*                          
## [167] print.Latex*                                        
## [168] print.LaTeX*                                        
## [169] print.libraryIQR                                    
## [170] print.lifecycle_warnings*                           
## [171] print.listof                                        
## [172] print.lm*                                           
## [173] print.loadings*                                     
## [174] print.locale*                                       
## [175] print.loess*                                        
## [176] print.logLik*                                       
## [177] print.ls_str*                                       
## [178] print.medpolish*                                    
## [179] print.MethodsFunction*                              
## [180] print.mtable*                                       
## [181] print.NativeRoutineList                             
## [182] print.news_db*                                      
## [183] print.nls*                                          
## [184] print.noquote                                       
## [185] print.numeric_version                               
## [186] print.object_size*                                  
## [187] print.octmode                                       
## [188] print.packageDescription*                           
## [189] print.packageInfo                                   
## [190] print.packageIQR*                                   
## [191] print.packageStatus*                                
## [192] print.pairwise.htest*                               
## [193] print.path*                                         
## [194] print.person*                                       
## [195] print.pillar*                                       
## [196] print.pillar_1e*                                    
## [197] print.pillar_colonnade*                             
## [198] print.pillar_ornament*                              
## [199] print.pillar_shaft*                                 
## [200] print.pillar_squeezed_colonnade*                    
## [201] print.pillar_tbl_format_setup*                      
## [202] print.pillar_vctr*                                  
## [203] print.pillar_vctr_attr*                             
## [204] print.POSIXct                                       
## [205] print.POSIXlt                                       
## [206] print.power.htest*                                  
## [207] print.ppr*                                          
## [208] print.prcomp*                                       
## [209] print.princomp*                                     
## [210] print.proc_time                                     
## [211] print.purrr_function_compose*                       
## [212] print.purrr_function_partial*                       
## [213] print.purrr_rate_backoff*                           
## [214] print.purrr_rate_delay*                             
## [215] print.quosure*                                      
## [216] print.quosures*                                     
## [217] print.R6*                                           
## [218] print.R6ClassGenerator*                             
## [219] print.raster*                                       
## [220] print.Rconcordance*                                 
## [221] print.Rd*                                           
## [222] print.recordedplot*                                 
## [223] print.rel*                                          
## [224] print.restart                                       
## [225] print.RGBcolorConverter*                            
## [226] print.RGlyphFont*                                   
## [227] print.rlang:::list_of_conditions*                   
## [228] print.rlang_box_done*                               
## [229] print.rlang_box_splice*                             
## [230] print.rlang_data_pronoun*                           
## [231] print.rlang_dict*                                   
## [232] print.rlang_dyn_array*                              
## [233] print.rlang_envs*                                   
## [234] print.rlang_error*                                  
## [235] print.rlang_fake_data_pronoun*                      
## [236] print.rlang_lambda_function*                        
## [237] print.rlang_message*                                
## [238] print.rlang_trace*                                  
## [239] print.rlang_warning*                                
## [240] print.rlang_zap*                                    
## [241] print.rle                                           
## [242] print.rlib_bytes*                                   
## [243] print.rlib_error_3_0*                               
## [244] print.rlib_trace_3_0*                               
## [245] print.roman*                                        
## [246] print.sass*                                         
## [247] print.sass_bundle*                                  
## [248] print.sass_layer*                                   
## [249] print.SavedPlots*                                   
## [250] print.scalar*                                       
## [251] print.sessionInfo*                                  
## [252] print.shiny.tag*                                    
## [253] print.shiny.tag.env*                                
## [254] print.shiny.tag.list*                               
## [255] print.shiny.tag.query*                              
## [256] print.simple.list                                   
## [257] print.smooth.spline*                                
## [258] print.socket*                                       
## [259] print.src*                                          
## [260] print.srcfile                                       
## [261] print.srcref                                        
## [262] print.stepfun*                                      
## [263] print.stl*                                          
## [264] print.stringr_view*                                 
## [265] print.StructTS*                                     
## [266] print.subdir_tests*                                 
## [267] print.summarize_CRAN_check_status*                  
## [268] print.summary.aov*                                  
## [269] print.summary.aovlist*                              
## [270] print.summary.ecdf*                                 
## [271] print.summary.glm*                                  
## [272] print.summary.lm*                                   
## [273] print.summary.loess*                                
## [274] print.summary.manova*                               
## [275] print.summary.nls*                                  
## [276] print.summary.packageStatus*                        
## [277] print.summary.ppr*                                  
## [278] print.summary.prcomp*                               
## [279] print.summary.princomp*                             
## [280] print.summary.table                                 
## [281] print.summary.warnings                              
## [282] print.summaryDefault                                
## [283] print.table                                         
## [284] print.tables_aov*                                   
## [285] print.tbl*                                          
## [286] print.terms*                                        
## [287] print.theme*                                        
## [288] print.tidyverse_conflicts*                          
## [289] print.tidyverse_logo*                               
## [290] print.trans*                                        
## [291] print.trunc_mat*                                    
## [292] print.ts*                                           
## [293] print.tskernel*                                     
## [294] print.TukeyHSD*                                     
## [295] print.tukeyline*                                    
## [296] print.tukeysmooth*                                  
## [297] print.undoc*                                        
## [298] print.uneval*                                       
## [299] print.unit*                                         
## [300] print.vctrs_bytes*                                  
## [301] print.vctrs_sclr*                                   
## [302] print.vctrs_unspecified*                            
## [303] print.vctrs_vctr*                                   
## [304] print.viewport*                                     
## [305] print.vignette*                                     
## [306] print.warnings                                      
## [307] print.xfun_raw_string*                              
## [308] print.xfun_rename_seq*                              
## [309] print.xfun_strict_list*                             
## [310] print.xgettext*                                     
## [311] print.xngettext*                                    
## [312] print.xtabs*                                        
## see '?methods' for accessing help and source code
```

果然有，我们还想继续查看每个方法的具体内容，我们试图通过直接打印`print.data.frame`，却找不到。我们需要使用`getAnywhere`函数来查找。


```r
list(getAnywhere("print.data.frame"), getAnywhere("print.tbl"))
```

```
## [[1]]
## A single object matching 'print.data.frame' was found
## It was found in the following places
##   package:base
##   registered S3 method for print from namespace base
##   namespace:base
## with value
## 
## function (x, ..., digits = NULL, quote = FALSE, right = TRUE, 
##     row.names = TRUE, max = NULL) 
## {
##     n <- length(row.names(x))
##     if (length(x) == 0L) {
##         cat(sprintf(ngettext(n, "data frame with 0 columns and %d row", 
##             "data frame with 0 columns and %d rows"), n), "\n", 
##             sep = "")
##     }
##     else if (n == 0L) {
##         print.default(names(x), quote = FALSE)
##         cat(gettext("<0 rows> (or 0-length row.names)\n"))
##     }
##     else {
##         if (is.null(max)) 
##             max <- getOption("max.print", 99999L)
##         if (!is.finite(max)) 
##             stop("invalid 'max' / getOption(\"max.print\"): ", 
##                 max)
##         omit <- (n0 <- max%/%length(x)) < n
##         m <- as.matrix(format.data.frame(if (omit) 
##             x[seq_len(n0), , drop = FALSE]
##         else x, digits = digits, na.encode = FALSE))
##         if (!isTRUE(row.names)) 
##             dimnames(m)[[1L]] <- if (isFALSE(row.names)) 
##                 rep.int("", if (omit) 
##                   n0
##                 else n)
##             else row.names
##         print(m, ..., quote = quote, right = right, max = max)
##         if (omit) 
##             cat(" [ reached 'max' / getOption(\"max.print\") -- omitted", 
##                 n - n0, "rows ]\n")
##     }
##     invisible(x)
## }
## <bytecode: 0x000001ebf0744a28>
## <environment: namespace:base>
## 
## [[2]]
## A single object matching 'print.tbl' was found
## It was found in the following places
##   registered S3 method for print from namespace pillar
##   namespace:pillar
## with value
## 
## function (x, width = NULL, ..., n = NULL, max_extra_cols = NULL, 
##     max_footer_lines = NULL) 
## {
##     print_tbl(x, width, ..., n = n, max_extra_cols = max_extra_cols, 
##         max_footer_lines = max_footer_lines)
## }
## <bytecode: 0x000001ebefe3efb8>
## <environment: namespace:pillar>
```

可以看到这俩函数差的很多，所以执行的内容不一样。我们再看看`t.test`。


```r
methods("t.test")
```

```
## [1] t.test.default* t.test.formula*
## see '?methods' for accessing help and source code
```

default就是默认方法，因为没有对应numeric的方法，所以我们输入两个向量进去的时候执行的就是default方法。我们只关注formula好了。


```r
getAnywhere("t.test.formula")
```

```
## A single object matching 't.test.formula' was found
## It was found in the following places
##   registered S3 method for t.test from namespace stats
##   namespace:stats
## with value
## 
## function (formula, data, subset, na.action, ...) 
## {
##     if (missing(formula) || (length(formula) != 3L)) 
##         stop("'formula' missing or incorrect")
##     oneSampleOrPaired <- FALSE
##     if (length(attr(terms(formula[-2L]), "term.labels")) != 1L) 
##         if (formula[[3L]] == 1L) 
##             oneSampleOrPaired <- TRUE
##         else stop("'formula' missing or incorrect")
##     m <- match.call(expand.dots = FALSE)
##     if (is.matrix(eval(m$data, parent.frame()))) 
##         m$data <- as.data.frame(data)
##     m[[1L]] <- quote(stats::model.frame)
##     m$... <- NULL
##     mf <- eval(m, parent.frame())
##     DNAME <- paste(names(mf), collapse = " by ")
##     names(mf) <- NULL
##     response <- attr(attr(mf, "terms"), "response")
##     if (!oneSampleOrPaired) {
##         g <- factor(mf[[-response]])
##         if (nlevels(g) != 2L) 
##             stop("grouping factor must have exactly 2 levels")
##         DATA <- split(mf[[response]], g)
##         y <- t.test(x = DATA[[1L]], y = DATA[[2L]], ...)
##         if (length(y$estimate) == 2L) {
##             names(y$estimate) <- paste("mean in group", levels(g))
##             names(y$null.value) <- paste("difference in means between", 
##                 paste("group", levels(g), collapse = " and "))
##         }
##     }
##     else {
##         respVar <- mf[[response]]
##         if (inherits(respVar, "Pair")) {
##             y <- t.test(x = respVar[, 1L], y = respVar[, 2L], 
##                 paired = TRUE, ...)
##         }
##         else {
##             y <- t.test(x = respVar, ...)
##         }
##     }
##     y$data.name <- DNAME
##     y
## }
## <bytecode: 0x000001ebf28ec918>
## <environment: namespace:stats>
```

可以看到他实际上就是先想办法把formula对应的内容变成一个df，然后执行`y = t.test(x = DATA[[1L]], y = DATA[[2L]], ...)`，然后再把向量输入进去，使用default方法。

### 实践

S3对象只关注方法，不关注数据，所以我们可以给随便一个数据随便定义一个类。也可以通过`structure`看起来更规范一点。


```r
x = list; class(x) = c("a", "b", "c")
y = structure(list(), class = c("a", "b", "c"))
list(class(x), class(y))
```

```
## [[1]]
## [1] "a" "b" "c"
## 
## [[2]]
## [1] "a" "b" "c"
```

我们尝试构建一下S3方法，其实十分简单，如果一个函数的内容仅仅只是`UseMethod("函数名")`的话，就会被识别成一个S3方法，然后我们只需要为这个S3方法写各个对象实现的细节。


```r
f = function(x) UseMethod("f")

f.a = function(x) return("Class a")

f.default = function(x) return("Unknown class")

x = structure(list(), class = "a")
y = structure(list(), class = c("b", "a"))
z = structure(list(), class = "c")

list(f(x), f(y), f(z))
```

```
## [[1]]
## [1] "Class a"
## 
## [[2]]
## [1] "Class a"
## 
## [[3]]
## [1] "Unknown class"
```

接下来我们看一个实例，`NextMethod`的作用是调用右边一个类的方法，假如每个类之间有明确的继承关系就可以用。但是并不是很好用，因为他会将参数原封不动的传给下一个方法，既然这样，那我们像上面t.test那样重新传参就好了。


```r
person   = structure(c(name = "A"), class = c("person"))
employee = structure(c(name = "B", job = "worker"), class = c("employee", "person"))
boss     = structure(c(name = "C", job = "manager", status = "rich"), class = c("boss", "employee", "person"))

introduce_yourself = function(person) UseMethod("introduce_yourself")

introduce_yourself.person = function(person_) {
  cat("---\nHi\n")
  cat("My name is", person_[["name"]], "\n")
}

introduce_yourself.employee = function(employee_) {
  NextMethod()
  cat("And I work as", employee_[["job"]], "\n")
}

introduce_yourself.boss = function(boss_) {
  NextMethod()
  cat("I am", boss_[["status"]], "\n")
}

introduce_yourself(person); introduce_yourself(employee); introduce_yourself(boss)
```

```
## ---
## Hi
## My name is A
```

```
## ---
## Hi
## My name is B 
## And I work as worker
```

```
## ---
## Hi
## My name is C 
## And I work as manager 
## I am rich
```

R的传参机制在以后可能有所介绍。

## R6

R6对象和其他语言的面向对象系统其实没啥区别了。在[R语言教程-基于tidyverse]()中有所提及，这里不再赘述。

我们把上面那个例子在R6中再实现一遍。

需要注意的是在S4和R6里我们先定义一个"类"，再把这个类实例化成一个"对象"。就类似于狗和熊熊的关系。在实例化的过程里，我们需要给这个实例提供一些信息，就是new或者initialize所需要的参数。


```r
library(R6)

person = R6Class( 
  classname = "anyone", 
  public = list( 
    name = NULL, 
    initialize = function(name, income) { 
      self$name = name 
      private$income = income 
    }, 
    printInfo = function() { 
      cat("---\nHi\n")
      cat("My name is", self$name, "\n")
      cat("I get", private$income, "a month", "\n")
      invisible(self) 
    }
  ), 
  private = list(income = NULL) 
)



employee = R6Class( 
  classname = "staff", 
  inherit = person, 
  public = list( 
    initialize = function(name, income, job) {
      super$initialize(name, income)
      private$job = job
    },
    printInfo = function() { 
      super$printInfo() 
      cat("And I work as", private$job, "\n")
    }
  ), 
  private = list(job = NULL)
)



boss = R6Class( 
  classname = "staff", 
  inherit = employee, 
  public = list( 
    initialize = function(name, income, job, status) {
      super$initialize(name, income, job)
      private$status = status
    },
    printInfo = function() { 
      super$printInfo() 
      cat("I am", private$status, "\n")
    }
  ), 
  private = list(status = NULL)
)

Jack = person$new("Jack", 100)
Mike = employee$new("Mike", 1000, "worker")
Bob = boss$new("Bob", 10000, "manager", "rich")

Mike$printInfo()
```

```
## ---
## Hi
## My name is Mike 
## I get 1000 a month 
## And I work as worker
```

```r
Jack$printInfo()
```

```
## ---
## Hi
## My name is Jack 
## I get 100 a month
```

```r
Bob$printInfo()
```

```
## ---
## Hi
## My name is Bob 
## I get 10000 a month 
## And I work as manager 
## I am rich
```

可以看到，同样的功能S3比R6实现简单很多，但是R6规范的多。R6十分重要，后面我们会再出一期R6专题欣赏优秀的面向对象工程。

## S4

S4对象只有历史意义了，功能比不上S3和R6。简单提及一下S4的特点就好了，S4的特点就是接近R的底层，因此十分不好用。S4中每个类会有一些默认的方法，比如show等，我们可以直接覆盖掉这些方法，如果方法不在默认方法里，则需要通过`setGeneric`注册一下，再添加方法。


```r
library(methods)

setClass(
  Class     = "IcecreamMachine",
  slots     = c(
    strawberry = "numeric",
    chocolate  = "numeric",
    mango      = "numeric"
  ),
  prototype = list(
    strawberry = 0,
    chocolate  = 0,
    mango      = 0
  )
)

setMethod(
  f           = "show",
  signature   = "IcecreamMachine",
  definition = function(object) {
    cat("*** Wounderful Icecream Machine! ***\n")
    cat("Taste:\n")
    cat("\tStrawberry: ", object@strawberry, "\n") 
    cat("\tChocolate: ", object@chocolate, "\n") 
    cat("\tMango: ", object@mango, "\n") 
  }
)

setGeneric(
  name = "getIcecream",
  def  = function(object,...) {
    standardGeneric("getIcecream")
  }
)

setMethod(
  f          = "getIcecream",
  signature  = "IcecreamMachine",
  definition = function(object, type) {
    slot(object, type) <- slot(object, type) - 1
    return(object)
  }
)

setGeneric(
  name = "setIce<-",
  def  = function(object, type, value) {
    standardGeneric("setIce<-")
  }
)

setReplaceMethod(
  f          = "setIce",
  signature  = "IcecreamMachine",
  definition = function(object, type, value) {
    slot(object, type) <- value        
    return(object)
  }
)

setMethod(
  f          = "[",
  signature  = "IcecreamMachine",
  definition = function(x,i,j,drop) {
    slot(x, i)
  }
)

setReplaceMethod(
  f          = "[",
  signature  = "IcecreamMachine",
  definition = function(x,i,j,value) {
    slot(x, i) = value
    validObject(x)
    return(x)
  }
)

setMethod(
  f          = "initialize",
  signature  = "IcecreamMachine",
  definition = function(.Object, strawberry, chocolate, mango) {        
    cat("Welcome to an icecream world!\n")        
    .Object@strawberry <- strawberry        
    .Object@chocolate  <- chocolate        
    .Object@mango      <- mango        
    return(.Object)
  }
) 

showMethods(classes = "IcecreamMachine")
getMethod("getIcecream", "IcecreamMachine")

first_machine = new("IcecreamMachine", 5, 3, 7)
```
