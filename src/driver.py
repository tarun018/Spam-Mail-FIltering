import os, string
from stop_words import get_stop_words
from nltk import word_tokenize          
from nltk.stem import WordNetLemmatizer
from sklearn.feature_extraction.text import CountVectorizer
from sklearn import datasets
from sklearn.naive_bayes import GaussianNB
from sklearn.metrics import classification_report
from numpy import concatenate
from sklearn import svm
from sklearn.neighbors import KNeighborsClassifier
from sklearn import tree
from sklearn.decomposition import PCA
import numpy as np
import random

def tanh(x):
	return np.tanh(x)

def tanh_deriv(x):
	return 1.0 - np.tanh(x)**2

def read_data(filename):
	with open(filename) as f:
		lines = f.readlines()

	data = []
	for line in lines:
		line = list(line)[:-1]
		inputs = [int(line[i]) for i in range(len(line) - 1)]
		output = int(line[-1])
		if output == 0:
			output = [1, 0]
		else:
			output = [0, 1]
		data.append([inputs, output])

	return data

class NN:
	def __init__(self, layers):
		self.ni = layers[0] + 1
		self.nh = layers[1] 
		self.no = layers[2]
		self.wh = np.zeros(shape=(self.ni, self.nh))
		self.wo = np.zeros(shape=(self.nh, self.no))

		for i in range(self.ni):
			for j in range(self.nh):
				self.wh[i][j] = random.uniform(-0.25, 0.25)

		for j in range(self.nh):
			for k in range(self.no):
				self.wo[j][k] = random.uniform(-0.25, 0.25)

		self.x = [1.0]*self.ni
		self.y = [1.0]*self.nh
		self.z = [1.0]*self.no

	def feed_forward(self, inputs):
		for i in range(self.ni - 1):
			self.x[i] = inputs[i]

		for j in range(self.nh):
			sum = 0.0
			for i in range(self.ni):
				sum += self.wh[i][j] * self.x[i]
			self.y[j] = tanh(sum)

		for k in range(self.no):
			sum = 0.0
			for j in range(self.nh):
				sum += self.wo[j][k] * self.y[j]
			self.z[k] = tanh(sum)

	def back_propagate(self, targets, eta):

		deltaks = [0.0] * self.no
		for k in range(self.no):
			e = targets[k] - self.z[k]
			deltaks[k] = e * tanh_deriv(self.z[k])

		deltajs = [0.0] * self.nh
		for j in range(self.nh):
			e = 0.0
			for k in range(self.no):
				e += self.wo[j][k] * deltaks[k]
			deltajs[j] = e * tanh_deriv(self.y[j])

		for j in range(self.nh):
			for k in range(self.no):
				delta_w = eta * deltaks[k] * self.y[j]
				self.wo[j][k] += delta_w

		for i in range(self.ni):
			for j in range(self.nh):
				delta_w = eta * deltajs[j] * self.x[i]
				self.wh[i][j] += delta_w

	def print_weights(self):
		print 'Input - Hidden: '
		for i in range(self.ni):
			print self.wh[i]
		print ''
		print 'Hidden - Output: '
		for j in range(self.nh):
			print self.wo[j]
		print " \\\\\n".join([" & ".join(map('{0:.2f}'.format, line)) for line in self.wo])

	def train(self, inputs, target, epochs=1):
		for i in range(epochs):
			for i in xrange(0, len(data)):
				self.feed_forward(inputs[i])
				self.back_propagate(targets[i], 0.1)
		self.print_weights()

	def test(self, inputs, targets):
		correct = 0
		total = 0
		for i in xrange(0, len(inputs)):

			self.feed_forward(inputs[i])
			if int(round(self.z[0])) == targets[i][0]:
				correct += 1
			total += 1
		print 'Accuracy:', (correct * 100.0)/total


def punctuate(text):
	content = "".join([ch for ch in text if ch not in string.punctuation])
	return content

def get_stop_removal():
	stop_words = get_stop_words('english')
	return stop_words

def lemmatize(path, inp, out):	
	wnl = WordNetLemmatizer()
	for file in os.listdir(path+inp+"/"):
		f = open(path+inp+"/"+file, "r")
		x = [wnl.lemmatize(t) for t in word_tokenize(f.read())]
		fw = open(path+out+"/"+file, "w")
		fw.write(' '.join(x))

def content_to_feature_vector(path):
	vectorizer = CountVectorizer(analyzer='word', min_df=1, stop_words=get_stop_removal())
	contents = []
	target = []
	for file in os.listdir(path):
		f = open(path+file, "r")
		#content = f.read()
		#content = lemmatize(content)
		#print str(content)

		if file[0]=='s':
			target.append(1)
		else:
			target.append(0)

		contents.append(f.read())
	
	## Getting the feature vectors
	feature_vectors = vectorizer.fit_transform(contents)
	feature_vectors = feature_vectors.toarray()
	## Getting the feature vector of document i : feature_vector[i]
	## Getting the Vocabulary
	vocab = vectorizer.get_feature_names()
	return (feature_vectors, target, vocab)

if __name__ == "__main__":
	#lemmatize("/home/tarun/finalsmai/lingspam_public/", "bare", "lemmatized"))
	#lemmatize("/home/tarun/finalsmai/lingspam_public2/", "bare", "lemmatized")
	#lemmatize("/home/tarun/finalsmai/lingspam_public3/", "bare", "lemmatized")

	train_data = content_to_feature_vector("/home/tarun/finalsmai/lingspam_public/lemmatized/")
	test_data = content_to_feature_vector("/home/tarun/finalsmai/lingspam_public2/lemmatized/")
	test1_data = content_to_feature_vector("/home/tarun/finalsmai/lingspam_public3/lemmatized/")


	train_features = train_data[0]
	train_target = train_data[1]

	test_features = concatenate((test_data[0], test1_data[0]))
	test_target = concatenate((test_data[1], test1_data[1]))

	pca = PCA(n_components=35000)
	train_features = pca.fit(train_features)
	test_features = pca.fit(test_features)
	

	## Classification NB
	#gnb = GaussianNB()
	#y_pred = gnb.fit(train_features, train_target).predict(test_features)
	#y_true = test_target
	#print("Number of mislabeled points out of a total %d points : %d"% (test_features.shape[0],(y_true != y_pred).sum()))

	## SVM Classification
	# clf = svm.SVC()
	# clf.fit(train_features, train_target)
	# y_pred = clf.predict(test_features)
	# y_true = test_target
	# print("Number of mislabeled points out of a total %d points : %d"% (test_features.shape[0],(y_true != y_pred).sum()))


	## KNN Classification
	# neigh = KNeighborsClassifier(n_neighbors=3, weights='uniform', metric='minkowski')
	# neigh.fit(train_features, train_target)
	# y_pred = neigh.predict(test_features)
	# y_true = test_target
	# print("Number of mislabeled points out of a total %d points : %d"% (test_features.shape[0],(y_true != y_pred).sum()))


	## Decision Trees
	#clf = tree.DecisionTreeClassifier()
	#clf = clf.fit(train_features, train_target)
	#y_pred = clf.predict(test_features)
	#y_true = test_target
	#print("Number of mislabeled points out of a total %d points : %d"% (test_features.shape[0],(y_true != y_pred).sum()))


	##Metrics
	target_names = ['Non Spam - 0', 'Spam - 1']
	print(classification_report(y_true, y_pred, target_names=target_names))


	from sklearn.externals.six import StringIO  
	import pydot 
	dot_data = StringIO() 
	tree.export_graphviz(clf, out_file=dot_data) 
	graph = pydot.graph_from_dot_data(dot_data.getvalue()) 
	graph.write_pdf("spam_full.pdf") 