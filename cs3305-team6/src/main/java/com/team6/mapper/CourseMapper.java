package com.team6.mapper;


import com.team6.pojo.Course;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CourseMapper {

    /**
     *
     */
    List<Course> findAllClass();


    Course selectByCourseId(@Param("courseId")Integer courseId);



    List<Course> selectByTeacherId(@Param("teacherId") Integer teacherId);

    int add(Course course);

    int update(Course course);

    int delete(Integer courseId);

}
