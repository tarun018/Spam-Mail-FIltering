import numpy as np
import matplotlib.pyplot as plt
import random
from sklearn import svm, preprocessing
from sklearn.metrics import confusion_matrix
from sknn.mlp import Classifier, Layer
import sys
import logging
from sklearn.metrics import classification_report as cr
from sklearn.naive_bayes import GaussianNB

def encode(vector):
	le = preprocessing.LabelEncoder()
	le.fit(vector)
	vector = le.transform(vector)
	print le.classes_
	return vector

def encodeAll(mat):
	categoricalIndices = []
	for i in categoricalIndices:
		mat[:,i] = encode(mat[:,i])
	return mat.astype(np.float)
from sklearn.metrics import confusion_matrix

def print_cm(cm, labels, hide_zeroes=False, hide_diagonal=False, hide_threshold=None):
	"""pretty print for confusion matrixes"""
	columnwidth = max([len(x) for x in labels]+[5]) # 5 is value length
	empty_cell = " " * columnwidth
	# Print header
	print "    " + empty_cell,
	for label in labels: 
		print "%{0}s".format(columnwidth) % label,
	print
	# Print rows
	for i, label1 in enumerate(labels):
		print "    %{0}s".format(columnwidth) % label1,
		for j in range(len(labels)): 
			cell = "%{0}.1f".format(columnwidth) % cm[i, j]
			if hide_zeroes:
				cell = cell if float(cm[i, j]) != 0 else empty_cell
			if hide_diagonal:
				cell = cell if i != j else empty_cell
			if hide_threshold:
				cell = cell if cm[i, j] > hide_threshold else empty_cell
			print cell,
		print

def train(X, ty):
	nn = Classifier(layers=[Layer("Sigmoid", units = 15), Layer("Softmax", units = 2)], learning_rate = 0.001, n_iter = 10, verbose = 1)
	nn.fit(X, ty)
	print "Train Done!"
	return nn

def train_bayes(X, y):
	gnb = GaussianNB()
	x = gnb.fit(X, y)
#	print gnb.class_count_
	return x

def predict(model, vector):
	return model.predict(vector)

def classify(model, featureVectors):
	z = model.predict(featureVectors[:, :-1]).astype(np.int).reshape(-1).tolist()
	data = featureVectors[:,-1].flatten()
	data = data.astype(np.int).tolist()
	labels = ['DOS', 'Normal', 'Probing', 'R2L', 'U2R']
	print cr(data, z)

file = open("train_features.txt")
file2 = open("test_features.txt")
featureVectors = []
normal_count = 0
r_count = 0
u_count = 0
prob_count = 0
dos_count = 0
limit = 1000
for line in file:	
	vector = line.strip().lower().split(',')
	featureVectors.append(vector)

featureVectors2  = []

for line in file2:
	vector = line.strip().lower().split(',')
	featureVectors2.append(vector)
logging.basicConfig(
			format="%(message)s",
			level=logging.DEBUG,
			stream=sys.stdout)

random.shuffle(featureVectors)
N = 1000
limit = (50 * N) / 100
mat = np.array(featureVectors[:N])[:,:]
mat = encodeAll(mat)
mat_test = np.array(featureVectors2[:N])[:,:]
mat_test = encodeAll(mat_test)
# print mat[1]
model = train_bayes(mat[:, :-1], mat[:, -1])
classify(model, mat_test[:, :])
