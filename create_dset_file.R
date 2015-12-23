library(shiny)
library(sqldf)
library(choroplethr)
library(choroplethrMaps)
library(ggplot2)
library(reshape2)
library(openintro)
library(stringr)

pathEnroll = "Data/Enrollment/"
enrollment <- ""
file.names <- dir(pathEnroll, pattern =".csv")
file.names <- paste("Data/Enrollment/", file.names, sep = "")
for(i in 1:length(file.names)){
  file <- read.csv(file.names[i],header=TRUE)
  year <- i + 2009
  file$year <- year
  enrollment <- rbind(enrollment, file)
}
subEnroll <- na.omit(enrollment)
subEnroll$State.Name <- tolower(abbr2state(subEnroll$State))
subEnroll$name <- paste(tolower(subEnroll$State.Name), tolower(subEnroll$County), sep = ",")

pathInfo = "Data/ContractInfo/"
contractInfo <- ""
file.names <- dir(pathInfo, pattern =".csv")
file.names <- paste("Data/ContractInfo/", file.names, sep = "")
for(i in 1:length(file.names)){
  file <- read.csv(file.names[i],header=TRUE)
  year <- i + 2009
  file$year <- year
  contractInfo <- rbind(contractInfo, file)
}
contractInfo <- na.omit(contractInfo)
contractSub <- unique(contractInfo[,c(1,11,13)])

subset <- merge(subEnroll, contractSub, by = c("Contract.ID","year"))

subset$Enrolled <- as.numeric(subset$Enrolled)
stateEnroll <- aggregate(Enrolled ~ year + State.Name, FUN = sum, data=subset)
porgEnroll <- aggregate(Enrolled ~ year + State.Name + Parent.Organization, FUN = sum, data=subset)

perc <- merge(stateEnroll, porgEnroll, by = c("year","State.Name"))
perc$percent <- as.integer(perc$Enrolled.y/perc$Enrolled.x*100)


years <- data.frame(year = c(2010,2011,2012,2013,2014,2015))
porg <- data.frame(Parent.Organization = c('Aetna Inc.',
                                           'Anthem Inc.',
                                           'UnitedHealth Group, Inc.',
                                           'Kaiser Foundation Health Plan, Inc.',
                                           'Humana Inc.',
                                           'CIGNA',
                                           'WellCare Health Plans, Inc.',
                                           'Health Net, Inc.',
                                           'Highmark Health'))

states <- as.data.frame(State.Name = c('alabama',
                                       'arizona',
                                       'arkansas',
                                       'california',
                                       'colorado',
                                       'connecticut',
                                       'delaware',
                                       'district of columbia',
                                       'florida',
                                       'georgia',
                                       'idaho',
                                       'illinois',
                                       'indiana',
                                       'iowa',
                                       'kansas',
                                       'kentucky',
                                       'louisiana',
                                       'maine',
                                       'maryland',
                                       'marz',
                                       'massachusetts',
                                       'michigan',
                                       'minnesota',
                                       'mississippi',
                                       'missouri',
                                       'montana',
                                       'nebraska',
                                       'nevada',
                                       'new hampshire',
                                       'new jersey',
                                       'new mexico',
                                       'new york',
                                       'north carolina',
                                       'north dakota',
                                       'ohio',
                                       'oklahoma',
                                       'oregon',
                                       'pennsylvania',
                                       'rhode island',
                                       'south carolina',
                                       'south dakota',
                                       'tennessee',
                                       'texas',
                                       'utah',
                                       'vermont',
                                       'virginia',
                                       'washington',
                                       'west virginia',
                                       'wisconsin',
                                       'wyoming',))
colnames(states) <- "State.Name"
mapr <- merge(states,porg,all=TRUE)
mapr <- merge(mapr,years,all=TRUE)

dset <- merge(x = mapr, y = perc, by = c("year","Parent.Organization","State.Name"), all.x = TRUE)
dset[is.na(dset)] <- 0


United <- dset[dset$Parent.Organization == "UnitedHealth Group, Inc.", ]
write.csv(United, "data/united.csv", row.names=FALSE)
Aetna <- dset[dset$Parent.Organization == "Aetna Inc.", ]
write.csv(Aetna, "data/aetna.csv", row.names=FALSE)
Kaiser <- dset[dset$Parent.Organization == "Kaiser Foundation Health Plan, Inc.", ]
write.csv(Kaiser, "data/kaiser.csv", row.names=FALSE)
Anthem <- dset[dset$Parent.Organization == "Anthem Inc.", ]
write.csv(Anthem, "data/anthem.csv", row.names=FALSE)
Humana  <- dset[dset$Parent.Organization == 'Humana Inc.', ]
write.csv(Humana, "data/humana.csv", row.names=FALSE)
CIGNA  <- dset[dset$Parent.Organization == 'CIGNA', ]
write.csv(CIGNA, "data/cigna.csv", row.names=FALSE)
WellCare  <- dset[dset$Parent.Organization == 'WellCare Health Plans, Inc.', ]
write.csv(WellCare, "data/wellcare.csv", row.names=FALSE)
HealthNet  <- dset[dset$Parent.Organization == 'Health Net, Inc.', ]
write.csv(HealthNet, "data/healthnet.csv", row.names=FALSE)
Highmark  <- dset[dset$Parent.Organization == 'Highmark Health', ]
write.csv(Highmark, "data/highmark.csv", row.names=FALSE)