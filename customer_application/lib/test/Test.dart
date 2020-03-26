void main(){
  for (var i = 0; i < 4; i++) {
    print('hello $i');
  }

  var myList = ['a','b','c','d','e'];
  print(myList);



  Map<String, int> scores = {'Bob': 36};


  for (var key in ['Bob', 'Rohan', 'Sophena']) {
  scores.putIfAbsent(key, () => key.length);
  }

  Map<int, String> grievanceTypes = new Map();
  for(int i = 0; i < myList.length; i++){
    grievanceTypes.putIfAbsent(
        i, ()=>myList[i]
    );
  }
  print(grievanceTypes);

}

test(data){
  return data.toString();
}