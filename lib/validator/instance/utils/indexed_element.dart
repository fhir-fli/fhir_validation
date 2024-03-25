import 'element.dart'; // Assuming an Element class exists that corresponds to the Element class in Java

class IndexedElement {
  int _index;
  Element? _match;
  Element? _entry;

  // Constructor with positional parameters, similar to the Java version
  IndexedElement(this._index, this._match, this._entry);

  // Getter for index
  int get index => _index;

  // Setter for index with method chaining by returning this instance
  IndexedElement setIndex(int index) {
    _index = index;
    return this;
  }

  // Getter for match
  Element? get match => _match;

  // Setter for match with method chaining by returning this instance
  IndexedElement setMatch(Element? match) {
    _match = match;
    return this;
  }

  // Getter for entry
  Element? get entry => _entry;

  // Setter for entry with method chaining by returning this instance
  IndexedElement setEntry(Element? entry) {
    _entry = entry;
    return this;
  }
}
