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
# tra_data = read_data('tra_processed.txt')
# test_data = read_data('test_processed.txt')


nn = NN([len(vocab), 7, 2])
nn.train(train_features, train_target)
nn.test(test_features, test_target)