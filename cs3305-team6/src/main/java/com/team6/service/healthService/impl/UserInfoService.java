package com.team6.service.healthService.impl;

import com.team6.mapper.HealthInfoRecordMapper;
import com.team6.mapper.UserInfoMapper;
import com.team6.pojo.HealthInfoRecord;
import com.team6.pojo.UserInfo;
import com.team6.request.UserInfoRequest;
import com.team6.response.HealthInfoRecordResponse;
import com.team6.response.UserInfoResponse;
import com.team6.service.healthService.IUserInfoService;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.exception.ServiceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author zhimin
 * 2026/2/18 01:32
 */
@Service
public class UserInfoService implements IUserInfoService {

    @Autowired
    private UserInfoMapper userInfoMapper;
    @Autowired
    private HealthInfoRecordMapper healthInfoRecordMapper;

    @Override
    public UserInfoResponse insertOrUpdateUserInfoAndAddLog(UserInfoRequest request) {
        if (request == null) {
            throw new ServiceException("Request cannot be null");
        }
        Long userId = SecurityUtils.getUserId();
        UserInfo entity = toEntity(request, userId);
        LocalDateTime now = LocalDateTime.now();
        entity.setCreatedAt(now);
        entity.setUpdatedAt(now);

        userInfoMapper.insertOrUpdate(entity);

        HealthInfoRecord record = toRecord(entity);
        record.setCreatedAt(now);
        healthInfoRecordMapper.insert(record);

        UserInfo saved = userInfoMapper.selectByUserId(userId);
        if (saved == null) {
            throw new ServiceException("User info save failed or data inconsistent");
        }
        return UserInfoResponse.from(saved);
    }

    private UserInfo toEntity(UserInfoRequest request, Long userId) {
        UserInfo e = new UserInfo();
        e.setUserId(userId);
        e.setNickname(request.getNickname());
        e.setWeight(request.getWeight());
        e.setHeight(request.getHeight());
        e.setAge(request.getAge());
        e.setGender(request.getGender());
        

        BigDecimal bmi = calculateBMI(request.getWeight(), request.getHeight());
        e.setBmi(bmi);
        

        BigDecimal bmr = calculateBMR(request.getWeight(), request.getHeight(), request.getAge(), request.getGender());
        e.setBmr(bmr);
        
        e.setStatus(request.getStatus() != null ? request.getStatus() : 1);
        return e;
    }


    private BigDecimal calculateBMI(BigDecimal weight, BigDecimal height) {
        if (weight == null || height == null || height.compareTo(BigDecimal.ZERO) == 0) {
            return null;
        }

        BigDecimal heightInMeters = height.divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);

        BigDecimal heightSquared = heightInMeters.multiply(heightInMeters);
        return weight.divide(heightSquared, 2, RoundingMode.HALF_UP);
    }

    private BigDecimal calculateBMR(BigDecimal weight, BigDecimal height, Integer age, Integer gender) {
        if (weight == null || height == null || age == null || gender == null) {
            return null;
        }

        BigDecimal base = BigDecimal.valueOf(10).multiply(weight)
                .add(BigDecimal.valueOf(6.25).multiply(height))
                .subtract(BigDecimal.valueOf(5).multiply(BigDecimal.valueOf(age)));
        

        BigDecimal constant = gender == 0 ? BigDecimal.valueOf(5) : BigDecimal.valueOf(-161);
        BigDecimal bmr = base.add(constant);
        
        return bmr.setScale(2, RoundingMode.HALF_UP);
    }

    @Override
    public UserInfoResponse getUserInfoByUserId() {
        Long userId = SecurityUtils.getUserId();
        UserInfo userInfo = userInfoMapper.selectByUserId(userId);
        return UserInfoResponse.from(userInfo);
    }

    @Override
    public List<HealthInfoRecordResponse> getUserInfoHistoryByUserId() {
        Long userId = SecurityUtils.getUserId();
        List<HealthInfoRecord> records = healthInfoRecordMapper.getRecordsByUserId(userId);
        if (records == null) {
            return Collections.emptyList();
        }
        return records.stream()
                .map(HealthInfoRecordResponse::from)
                .collect(Collectors.toList());
    }

    private HealthInfoRecord toRecord(UserInfo info) {
        HealthInfoRecord r = new HealthInfoRecord();
        r.setUserId(info.getUserId());
        r.setNickname(info.getNickname());
        r.setWeight(info.getWeight());
        r.setHeight(info.getHeight());
        r.setAge(info.getAge());
        r.setGender(info.getGender());
        r.setBmi(info.getBmi());
        r.setBmr(info.getBmr());
        r.setStatus(info.getStatus() != null ? info.getStatus() : 1);
        return r;
    }
}
