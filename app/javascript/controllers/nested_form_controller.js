import NestedForm from "stimulus-rails-nested-form";

export default class extends NestedForm {
  connect() {
    super.connect();
    console.log("Stimulus nested form controller connected");
  }
}
