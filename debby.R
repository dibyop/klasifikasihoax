library(caret)
library(tm)
library(SnowballC)
library(arm)
# Training data.
data <- c('KM Sinar Bangun Ditemukan di Kedalaman 450 Meter Danau Toba','tenggelamnya kapal KM Sinar Bangun diduga karena kelebihan muatan',
          'Sebanyak 14 korban selamat dari peristiwa tenggelamnya KM Sinar Bangun','korban hilang sebanyak 189 orang',
          'Pesawat Hercules dengan tipe C-130 H/HS/L-100-30 dan nomor seri A-1323 ini membawa tim Basarnas dari Jakarta untuk membantu mencari korban hilang KM Sinar Bangun',
          'BMKG sudah beri peringatan dini pada KM Sinar Bangun','Ditemukan 1 korban meninggal dunia pada hari ketiga',
          'Pencarian korban kapal tenggelam KM Sinar Bangun di perairan Danau Toba terus dilanjutkan hingga 25 Juni.','sebelum tenggelam terdapat pesta miras didalam kapal',
          'sepasang kekasih yang akan menikah menjadi korban tenggelamnya KM Sinar Bangun',
          'tenggelamnya KM Sinar Bangun akibat menangkap ikan mas di danau toba','pemancing tidak mendengar nasehat tetua','banyak kapal ilegal di danau toba',
          'banyak mitos pada danau toba','tenggelamnya KM Sinar Bangun akibat kesalahan nahkoda',
          'paranormal ikut mencari KM Sinar Bangun','cuaca buruk dipicu penangkapan ikan mas didanau toba','banyak korban selamat',
          'ikan mas dipercaya merupakan sosok penunggu di danau toba','ikan mas di danau toba dipercaya adalah sosok seorang wanita')
corpus <- VCorpus(VectorSource(data))

# Create a document term matrix.
tdm <- DocumentTermMatrix(corpus, list(removePunctuation = TRUE, stopwords = TRUE, stemming = TRUE, removeNumbers = TRUE))

# Convert to a data.frame for training and assign a classification (factor) to each document.
train <- as.matrix(tdm)
train <- cbind(train, c(0, 1))
colnames(train)[ncol(train)] <- 'y'
train <- as.data.frame(train)
train$y <- as.factor(train$y)
data
train
# Train.
fit <- train(y ~ ., data = train, method = 'bayesglm')

# Check accuracy on training.
predict(fit, newdata = train)

# Test data.
data2 <- c('KM Sinar Bangun Ditemukan di Kedalaman 450 Meter Danau Toba','tenggelamnya kapal KM Sinar Bangun diduga karena kelebihan muatan',
           'Sebanyak 14 korban selamat dari peristiwa tenggelamnya KM Sinar Bangun','korban hilang sebanyak 189 orang',
           'Pesawat Hercules dengan tipe C-130 H/HS/L-100-30 dan nomor seri A-1323 ini membawa tim Basarnas dari Jakarta untuk membantu mencari korban hilang KM Sinar Bangun',
           'tenggelamnya KM Sinar Bangun akibat menangkap ikan mas di danau toba','pemancing tidak mendengar nasehat tetua',
           'banyak kapal ilegal di danau toba','banyak mitos pada danau toba','tenggelamnya KM Sinar Bangun akibat kesalahan nahkoda',)
corpus <- VCorpus(VectorSource(data2))
tdm <- DocumentTermMatrix(corpus, control = list(dictionary = Terms(tdm), removePunctuation = TRUE, stopwords = TRUE, stemming = TRUE, removeNumbers = TRUE))
test <- as.matrix(tdm)

# Check accuracy on test.
predict(fit, newdata = test)