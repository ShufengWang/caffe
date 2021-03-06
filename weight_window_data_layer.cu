#include <vector>

#include "caffe/data_layers.hpp"

namespace caffe {

template <typename Dtype>
void WeightWindowDataLayer<Dtype>::Forward_gpu(
    const vector<Blob<Dtype>*>& bottom, const vector<Blob<Dtype>*>& top) {
  // First, join the thread
  this->JoinPrefetchThread();
  // Reshape to loaded data.
  top[0]->ReshapeLike(this->prefetch_data_);
  // Copy the data
  caffe_copy(this->prefetch_data_.count(), this->prefetch_data_.cpu_data(),
      top[0]->mutable_gpu_data());
  if (this->output_labels_) {
    // Reshape to loaded labels.
    top[1]->ReshapeLike(this->prefetch_label_);
    // Copy the labels.
    caffe_copy(this->prefetch_label_.count(), this->prefetch_label_.cpu_data(),
        top[1]->mutable_gpu_data());
  }
 
  top[2]->ReshapeLike(this->prefetch_weight_);
  caffe_copy(this->prefetch_weight_.count(), this->prefetch_weight_.cpu_data(),
				top[2]->mutable_gpu_data());

  

  // Start a new prefetch thread
  this->CreatePrefetchThread();
}

INSTANTIATE_LAYER_GPU_FORWARD(WeightWindowDataLayer);

}  // namespace caffe
