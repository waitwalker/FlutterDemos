import 'package:online_school/model/course_model.dart';
import 'package:redux/redux.dart';

final CourseReducer = combineReducers<List<CourseEntity>>([
  TypedReducer<List<CourseEntity>, UpdateCCCourseAction>(_updateLoaded),
]);

List<CourseEntity> _updateLoaded(List<CourseEntity> courses, action) {
  // courses = action.courses;
  List<CourseEntity>
      newState; // = action.append ? courses.addAll(action.courses)??courses : action.courses;
  if (action.append) {
    courses.addAll(action.courses);
    return courses;
  }
  return action.courses;
}

class UpdateCCCourseAction {
  final List<CourseEntity> courses;
  final bool append;

  UpdateCCCourseAction(this.courses, {this.append: false});
}
