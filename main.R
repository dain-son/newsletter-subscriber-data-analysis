
library(tidyverse)
library(dplyr)
library(extrafont)
library(lubridate)
font_import()
df<- read_csv('/Users/dainson/Downloads/기본 주소록_20231204/data.csv')

View(df)
df<- rename(df, c(receive="이메일 수신 상태")) colnames(df)
class(df$YMD)
df |> group_by(receive)
   |>  summarise(count = n())
   |>  ggplot(aes(x=receive, y=count)) +
  geom_bar(stat='identity')+
  theme_minimal(base_family="NanumGothic")+
  geom_text(aes(label=count), vjust=-0.7)+
  labs(title="",
        x="2022-12-05~2023-12-04", y="")+
  theme(plot.title=element_text(size=10, hjust=.5))

datebreaks<- seq(as.Date("2022-12-05"),
  as.Date("2023-12-04",
  by="2 month"))

df<- df|> mutate(YMD= as.Date(구독일)) df |> group_by(YMD) |>
    summarise(count=n()) |>
    mutate(YM = format(YMD, "%Y-%m")) |>   group_by(YM) |>
    summarise(count_m = sum(count))|>

    ggplot(aes(x=YM, y=cumsum(count_m) ))+
    geom_line(aes(x=YM, y=cumsum(count_m),group=1))+   geom_bar(aes(x=YM, y=count_m),stat='identity')+   theme_minimal(base_family="NanumGothic")+
    labs(title="구독자 수 변화", x="날짜", y="누적 구독자 수")+
    theme(plot.title=element_text(size=10, hjust=.5),
    axis.text.x = element_text(angle=30))+
    geom_text(aes(label=count_m), vjust=-1, check_overlap=True)

# 구독자 별 오픈율
df<- df |> mutate(오픈율_구간 = case_when(오픈율 <= 0 ~ "0"
                                       오픈율<= 10 ~ "10미만",
                                     오픈율<= 20 ~ "10대",
                                     오픈율<= 30 ~ "20대",
                                     오픈율<= 40 ~ "30대",
                                     오픈율<= 50 ~ "40대",
                                     오픈율<= 60 ~ "50대",
                                     오픈율<= 70 ~ "60대",
                                     오픈율<= 80 ~ "70대",
                                     오픈율<= 90 ~ "80대",
                                     오픈율<= 100 ~ "90이상",))

df |> filter(receive =="구독 중") |>
    group_by(오픈율_구간) |>
    summarise(count=n()) |>
    ggplot(aes(x=오픈율_구간, y=count))+
    geom_bar(stat='identity')+
    theme_classic(base_family="AppleGothic")+
    theme(plot.title=element_text(size=10, hjust=.5),
    axis.text.x = element_text(angle=30))+
    scale_x_discrete(limits=c("0","10미만","10대","20대","30대",
  "40대","50대",
  "60대","70대",
  "80대","90이상"))+
    geom_text(aes(label=count), vjust=-0.5,size=3)+   labs(title="수신상태 구독자 오픈율", x="오픈율", y="")

df|> filter(receive=="구독 중" & 
            오픈율_구간 =="10미만") |>
  ggplot(aes(x=오픈율)) +
  geom_bar(stat="bin")+
  labs(title="10% 미만 오픈율 구독자 분포")+
  theme_minimal(base_family="NanumGothic")+
  theme(plot.title=element_text(size=15, hjust=.5))


                                     
