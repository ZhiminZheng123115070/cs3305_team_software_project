package com.team6.mapper;

import com.team6.pojo.Storage;
import com.team6.response.StorageResponse;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @author zhimin
 * 2026/2/8 18:52
 */
@Mapper
public interface StorageMapper {

    /**
     * Add or update storage item (if same user_id + product_id exists, increase quantity)
     * @param storage Storage item
     * @return Number of affected rows
     */
    int addStorage(Storage storage);
    
    /**
     * Update storage quantity (for consumption tracking)

     * @return Number of affected rows
     */
    int updateStorage(Storage request);
    
    /**
     * Delete storage item
     * @param storageId Storage ID
     * @param userId User ID (for security check)
     * @return Number of affected rows
     */
    int deleteStorage(@Param("storageId") Long storageId, @Param("userId") Long userId);

    StorageResponse findStorageById(@Param("storageId") Long StorageId);

    List<StorageResponse> findStoragesByUserId(@Param("userId") Long userId);






}
