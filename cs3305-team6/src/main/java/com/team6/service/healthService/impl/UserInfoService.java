package com.team6.service.healthService.impl;

import com.team6.mapper.HealthInfoRecordMapper;
import com.team6.mapper.UserInfoMapper;
import com.team6.pojo.HealthInfoRecord;
import com.team6.pojo.UserInfo;
import com.team6.request.UserInfoRequest;
import com.team6.response.UserInfoResponse;
import com.team6.service.healthService.IUserInfoService;
import com.ruoyi.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

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
    public UserInfoResponse addUserInfoAndLog(UserInfoRequest request) {
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
        e.setBmi(request.getBmi());
        e.setBmr(request.getBmr());
        e.setEnergyKcal(request.getEnergyKcal());
        e.setFat(request.getFat());
        e.setSaturatedFat(request.getSaturatedFat());
        e.setCarbohydrates(request.getCarbohydrates());
        e.setSugars(request.getSugars());
        e.setFiber(request.getFiber());
        e.setProteins(request.getProteins());
        e.setSalt(request.getSalt());
        e.setStatus(request.getStatus() != null ? request.getStatus() : 1);
        return e;
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
